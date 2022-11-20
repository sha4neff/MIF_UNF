#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ДоступныеКалендари = ДоступныеСотрудникуКалендари().ВыгрузитьКолонку("Календарь");
	Параметры.Отбор.Вставить("Ссылка", ДоступныеКалендари);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Возвращает список календарей, в которых сотрудник является владельцем или участником.
//
// Параметры:
//  Сотрудник - СправочникСсылка.Сотрудники - Ответственный сотрудник, для которого требуется получить календари.
//                                            По умолчанию - сотрудник текущего пользователя.
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//    * Календарь - СправочникСсылка.КалендариСотрудников - Календарь сотрудника.
//    * Наименование - Строка - Строковое представление календаря.
//    * ЯвляетсяВладельцем - Булево - Показывает является ли переданный сотрудник владельцем текущего календаря.
//
Функция ДоступныеСотрудникуКалендари(Сотрудник = Неопределено) Экспорт
	
	Если Сотрудник = Неопределено Тогда
		СотрудникиПользователя = РегистрыСведений.СотрудникиПользователя.ПолучитьСотрудниковПользователя();
	Иначе
		СотрудникиПользователя = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КалендариСотрудников.Ссылка КАК Календарь
	|ПОМЕСТИТЬ ВТКалендари
	|ИЗ
	|	Справочник.КалендариСотрудников КАК КалендариСотрудников
	|ГДЕ
	|	НЕ КалендариСотрудников.Предопределенный
	|	И КалендариСотрудников.ПометкаУдаления = ЛОЖЬ
	|	И КалендариСотрудников.ВладелецКалендаря В(&СотрудникиПользователя)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КалендариСотрудниковДоступ.Ссылка
	|ИЗ
	|	Справочник.КалендариСотрудников.Доступ КАК КалендариСотрудниковДоступ
	|ГДЕ
	|	НЕ КалендариСотрудниковДоступ.Ссылка.Предопределенный
	|	И КалендариСотрудниковДоступ.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И КалендариСотрудниковДоступ.Сотрудник В(&СотрудникиПользователя)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТКалендари.Календарь КАК Календарь,
	|	ВТКалендари.Календарь.Наименование КАК Наименование,
	|	ВЫБОР
	|		КОГДА ВТКалендари.Календарь.ВладелецКалендаря В (&СотрудникиПользователя)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЯвляетсяВладельцем
	|ИЗ
	|	ВТКалендари КАК ВТКалендари
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЯвляетсяВладельцем УБЫВ,
	|	Наименование";
	
	Запрос.УстановитьПараметр("СотрудникиПользователя", СотрудникиПользователя);
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Если Пользователи.ЭтоПолноправныйПользователь() И ПолучитьФункциональнуюОпцию("ИспользоватьОтчетность") Тогда
		
		НоваяСтрока = Таблица.Добавить();
		НоваяСтрока.Календарь = КалендарьНалогов;
		НоваяСтрока.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КалендарьНалогов, "Наименование");
		НоваяСтрока.ЯвляетсяВладельцем = Ложь;
		
	КонецЕсли;
	
	Возврат Таблица;
	
КонецФункции

// Возвращает для каждого сотрудника календарь, выбранный как основной.
// 
// Возвращаемое значение:
//  Соответствие
//    * Ключ - СправочникСсылка.Сотрудники
//    * Значение - СправочникСсылка.КалендариСотрудников, Неопределено
//
Функция ОсновныеКалендариСотрудников() Экспорт
	
	ОсновныеКалендариСотрудников = КалендариСотрудниковОтмеченныеКакОсновнойУПользователя();
	ВсеСотрудники = Справочники.Сотрудники.Выбрать();
	
	Результат = Новый Соответствие;
	Пока ВсеСотрудники.Следующий() Цикл
		Сотрудник = ВсеСотрудники.Ссылка;
		Результат.Вставить(Сотрудник, ОсновныеКалендариСотрудников.Получить(Сотрудник));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СсылкаПоИдентификатору(Идентификатор, Пользователь) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	КалендариСотрудников.Ссылка
	|ИЗ
	|	Справочник.КалендариСотрудников КАК КалендариСотрудников
	|ГДЕ
	|	КалендариСотрудников.Пользователь = &Пользователь
	|	И КалендариСотрудников.key = &key");
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("key",
	ОбменСGoogle.КлючИзИдентификатора(Идентификатор, ТипЗнч(Справочники.КалендариСотрудников)));
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Справочники.КалендариСотрудников.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Ссылка;
	
КонецФункции

Процедура ПроверитьСоздатьКалендарьСотрудника(Сотрудник, Пользователь = Неопределено) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	КалендариСотрудников.Ссылка
		|ИЗ
		|	Справочник.КалендариСотрудников КАК КалендариСотрудников
		|ГДЕ
		|	КалендариСотрудников.ВладелецКалендаря = &ВладелецКалендаря
		|	И КалендариСотрудников.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("ВладелецКалендаря", Сотрудник);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ВладелецКалендаря", Сотрудник);
	ДанныеЗаполнения.Вставить("Пользователь", Пользователь);
	ДанныеЗаполнения.Вставить("Наименование", Строка(Сотрудник));
	
	НовыйКалендарь = Справочники.КалендариСотрудников.СоздатьЭлемент();
	НовыйКалендарь.УстановитьНовыйКод();
	НовыйКалендарь.Заполнить(ДанныеЗаполнения);
	НовыйКалендарь.Записать();
	
	УправлениеНебольшойФирмойСервер.УстановитьНастройкуПользователя(НовыйКалендарь.Ссылка, "ОсновнойКалендарь", Пользователь);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоАвторизованныйПользователь(Пользователь)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КалендариСотрудниковОтмеченныеКакОсновнойУПользователя()
	
	ОсновныеКалендариСотрудников = Новый Соответствие;
	
	ВсеКалендариСотрудников = Справочники.КалендариСотрудников.Выбрать();
	Пока ВсеКалендариСотрудников.Следующий() Цикл
		ОсновнойКалендарьПользователя = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			ВсеКалендариСотрудников.Пользователь, "ОсновнойКалендарь");
		Если ВсеКалендариСотрудников.Ссылка = ОсновнойКалендарьПользователя Тогда
			ОсновныеКалендариСотрудников.Вставить(ВсеКалендариСотрудников.ВладелецКалендаря, ВсеКалендариСотрудников.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОсновныеКалендариСотрудников;
	
КонецФункции

#КонецОбласти

#КонецЕсли