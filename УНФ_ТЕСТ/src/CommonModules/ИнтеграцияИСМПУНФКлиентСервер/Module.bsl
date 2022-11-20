#Область ПодключаемыеКомандыИСКлиентСерверПереопределяемый

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
//  Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыМаркировкиТоваровИСМП(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ОприходованиеЗапасов",	НСтр("ru = 'Оприходование запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"СборкаЗапасов",			НСтр("ru = 'Производство'"), "ИспользоватьПодсистемуПроизводство");
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПриходнаяНакладная",		НСтр("ru = 'Приходную накладную'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ОприходованиеЗапасов",	НСтр("ru = 'Оприходование запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"СборкаЗапасов",			НСтр("ru = 'Производство'"), "ИспользоватьПодсистемуПроизводство");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ИнвентаризацияЗапасов",	НСтр("ru = 'Инвентаризацию запасов'"));
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
//  Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыЗаказНаЭмиссиюКодовМаркировкиСУЗ(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "МаркировкаТоваровИСМП",		НСтр("ru = 'Ввод в оборот ИС МП'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПеремаркировкаТоваровИСМП",	НСтр("ru = 'Перемаркировка ИС МП'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ЗаказПоставщику",			НСтр("ru = 'Заказ поставщику'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ЗаказНаПроизводство",		НСтр("ru = 'Заказ на производство'"));
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
//  Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыВыводаИзОборотаИСМП(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "СписаниеЗапасов",	НСтр("ru = 'Списание запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "СборкаЗапасов",		НСтр("ru = 'Разборку запасов'"), "ИспользоватьПодсистемуПроизводство");
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "РасходнаяНакладная",			НСтр("ru = 'Расходную накладную'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ОтчетОРозничныхПродажах",	НСтр("ru = 'Отчет о розничных продажах'"), "УчетРозничныхПродаж");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ЧекККМ",						НСтр("ru = 'Чек ККМ'"), "УчетРозничныхПродаж");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "РасходнаяНакладная",			НСтр("ru = 'Возврат товаров поставщику'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "СписаниеЗапасов",			НСтр("ru = 'Списание запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "СборкаЗапасов",				НСтр("ru = 'Производство'"), "ИспользоватьПодсистемуПроизводство");
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
//  Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыСписанияКодовМаркировкиИСМП(Команды) Экспорт 
	
	Возврат;
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
//  Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыПеремаркировкиТоваровИСМП(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПриходнаяНакладная",	НСтр("ru = 'Возврат товаров от клиента'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ЧекККМВозврат",		НСтр("ru = 'Чек ККМ на возврат'"));
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
//  Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыОтгрузкиТоваровИСМП(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "РасходнаяНакладная",	НСтр("ru = 'Расходная накладная'"));
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандЗаказаНаЭмиссию(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандМаркировкиТоваров(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	Операция = Форма.Объект.Операция;
	
	Для Каждого КлючИЗначение Из Форма.ВидимостьПодключаемыхКоманд Цикл
		
		ИмяМетаданных	= КлючИЗначение.Значение.ИмяМетаданных;
		Элемент			= Форма.Элементы[КлючИЗначение.Ключ];
		
		Если Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоВнеЕАЭС")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПолучениеПродукцииОтФизическихЛиц") Тогда
			Элемент.Видимость = ИмяМетаданных = "ПриходнаяНакладная";
		ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФ") Тогда
			Если ИмяМетаданных = "СборкаЗапасов"
				Или ИмяМетаданных = "ОприходованиеЗапасов" Тогда
				Элемент.Видимость = Истина
			КонецЕсли;
		ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотМаркировкаОстатков") Тогда
			Элемент.Видимость = ИмяМетаданных = "ИнвентаризацияЗапасов";
		Иначе
			Элемент.Видимость = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандВыводаВОборота(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	Операция = Форма.Объект.Операция;
	
	Для Каждого КлючИЗначение Из Форма.ВидимостьПодключаемыхКоманд Цикл
		
		ИмяМетаданных	= КлючИЗначение.Значение.ИмяМетаданных;
		Элемент			= Форма.Элементы[КлючИЗначение.Ключ];
		
		Если Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаВозвратФизическомуЛицу") Тогда
			Элемент.Видимость = ИмяМетаданных = "РасходнаяНакладная";
		ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаБезвозмезднаяПередача") Тогда
			Элемент.Видимость = ИмяМетаданных = "СписаниеЗапасов";
		ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляСобственныхНуждПредприятия") Тогда
			Если ИмяМетаданных = "СборкаЗапасов" Тогда
				Элемент.Видимость = Форма.Объект.Товары.Количество() = 1;
			Иначе
				Элемент.Видимость = ИмяМетаданных = "СписаниеЗапасов";
			КонецЕсли;
		ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаВПроцессеРеализацииПоДоговоруРассрочки")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКредитныйДоговор")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРеализацияКонфискованныхТоваров")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРеализацияПоДоговоруРассрочки")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортВСтраныЕАЭС")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортЗаПределыСтранЕАЭС") Тогда
			Элемент.Видимость = ИмяМетаданных = "РасходнаяНакладная";
		ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКонфискацияТовара")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЛиквидацияПредприятия")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУничтожениеТовара")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара") Тогда
			Элемент.Видимость = ИмяМетаданных = "СписаниеЗапасов";
		ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа") Тогда
			Элемент.Видимость = (ИмяМетаданных = "РасходнаяНакладная"
				Или ИмяМетаданных = "ОтчетОРозничныхПродажах"
				Или ИмяМетаданных = "ЧекККМ");
		Иначе
			Элемент.Видимость = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандСписанияКодовМаркировки(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандПеремаркировкиТоваров(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандОтгрузкиТоваров(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияИСМПКлиентСерверПереопределяемый

Процедура ЗаполнитьСоответствиеПолейДокументовОснований(Форма, СоответствиеПолей) Экспорт
	
	Если СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ") Тогда
		
		СоответствиеПолей.Вставить("ЗаказПоставщику", Новый Соответствие);
		СоответствиеПолей["ЗаказПоставщику"].Вставить("Организация",   "Организация");
		
		СоответствиеПолей.Вставить("ЗаказНаПроизводство", Новый Соответствие);
		СоответствиеПолей["ЗаказНаПроизводство"].Вставить("Организация",   "Организация");
		
	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "Документ.МаркировкаТоваровИСМП") Тогда
		
		СоответствиеПолей.Вставить("СборкаЗапасов", Новый Соответствие);
		СоответствиеПолей["СборкаЗапасов"].Вставить("Организация", "Организация");
		СоответствиеПолей["СборкаЗапасов"].Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийСборкаЗапасов.Сборка"), "ВидОперации");
		
		СоответствиеПолей.Вставить("ПриходнаяНакладная", Новый Соответствие);
		СоответствиеПолей["ПриходнаяНакладная"].Вставить("Организация", "Организация");
		
		СоответствиеПолей.Вставить("ОприходованиеЗапасов", Новый Соответствие);
		СоответствиеПолей["ОприходованиеЗапасов"].Вставить("Организация", "Организация");
		
	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ВыводИзОборотаИСМП") Тогда
		
		СоответствиеПолей.Вставить("ЧекККМ", Новый Соответствие);
		СоответствиеПолей["ЧекККМ"].Вставить("Организация", "Организация");
		
		СоответствиеПолей.Вставить("РасходнаяНакладная", Новый Соответствие);
		СоответствиеПолей["РасходнаяНакладная"].Вставить("Организация", "Организация");
		
		СоответствиеПолей.Вставить("ОтчетОРозничныхПродажах", Новый Соответствие);
		СоответствиеПолей["ОтчетОРозничныхПродажах"].Вставить("Организация", "Организация");
		
		СоответствиеПолей.Вставить("СписаниеЗапасов", Новый Соответствие);
		СоответствиеПолей["СписаниеЗапасов"].Вставить("Организация", "Организация");
		
		СоответствиеПолей.Вставить("СборкаЗапасов", Новый Соответствие);
		СоответствиеПолей["СборкаЗапасов"].Вставить("Организация", "Организация");
		
	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ПеремаркировкаТоваровИСМП") Тогда
		
		СоответствиеПолей.Вставить("ПриходнаяНакладная", Новый Соответствие);
		СоответствиеПолей["ПриходнаяНакладная"].Вставить("Организация", "Организация");
		СоответствиеПолей["ПриходнаяНакладная"].Вставить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя"), "ВидОперации");
		
		СоответствиеПолей.Вставить("ЧекККМВозврат", Новый Соответствие);
		СоответствиеПолей["ЧекККМВозврат"].Вставить("Организация", "Организация");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Устанавливает параметры выбора номенклатуры.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой нужно установить параметры выбора,
//  ИмяПоляВвода - Строка - имя поля ввода номенклатуры.
Процедура УстановитьПараметрыВыбораНоменклатуры(Форма, ВидыПродукцииИС = Неопределено, ИмяПоляВвода = "ТоварыНоменклатура") Экспорт
	
	ПараметрыВыбора = Новый Массив;
	
	Если ТипЗнч(ВидыПродукцииИС) = Тип("Массив") Тогда
		
		Для Каждого ВидПродукцииИС Из ВидыПродукцииИС Цикл
			
			ЗаполнитьПараметрыВыбораНоменклатурыПоВидуПродукции(ПараметрыВыбора, ВидПродукцииИС);
			
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ВидыПродукцииИС) = Тип("ПеречислениеСсылка.ВидыПродукцииИС") Тогда
		
		ВидПродукцииИС = ВидыПродукцииИС;
		ЗаполнитьПараметрыВыбораНоменклатурыПоВидуПродукции(ПараметрыВыбора, ВидПродукцииИС);
		
	КонецЕсли;
	
	Если ПараметрыВыбора.Количество() Тогда
		
		Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
		
	КонецЕсли;
	
КонецПроцедуры

// Определяет соответствие переданного документа проверяемому типу.
//
// Параметры:
//  Контекст - УправляемаяФорма, ДокументСсылка - Контекст для определения типа документа.
//  Имя      - Строка - имя объекта метаданного документа.
//
// Возвращаемое значение:
// 	Булево - это документ.
Функция ЭтоДокументПоНаименованию(Контекст, Имя) Экспорт
	
	Результат = Ложь;
	
	ТипКонтекста = ТипЗнч(Контекст);
	ТипДокумента = Тип(СтрШаблон("ДокументСсылка.%1", Имя));
	
	Если ТипКонтекста = Тип("УправляемаяФорма") Тогда
		Если СтрНачинаетсяС(Контекст.ИмяФормы, СтрШаблон("Документ.%1", Имя)) Тогда
			Результат = Истина;
		КонецЕсли;
	ИначеЕсли ТипКонтекста = ТипДокумента Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает параметры выбора номенклатуры.
//
// Параметры:
//  ПараметрыВыбора - Массив - параметры выбора элемента формы "Номенклатура".
//  ВидПродукцииИС - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции ИС.
//
Процедура ЗаполнитьПараметрыВыбораНоменклатурыПоВидуПродукции(ПараметрыВыбора, ВидПродукцииИС) Экспорт
	
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ТипНоменклатуры", ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Запас")));
	
КонецПроцедуры

#КонецОбласти