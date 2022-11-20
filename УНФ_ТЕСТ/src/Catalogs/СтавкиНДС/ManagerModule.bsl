#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиОбновления

Процедура ЗаполнитьВидыСтавокНДС() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтавкиНДС.Ссылка КАК Ссылка,
	|	СтавкиНДС.Ставка КАК Ставка,
	|	СтавкиНДС.НеОблагается КАК НеОблагается,
	|	СтавкиНДС.Расчетная КАК Расчетная
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	
	Пока Выборка.Следующий() Цикл
		
		СтавкиНДСОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СтавкиНДСОбъект.ВидСтавкиНДС = Перечисления.ВидыСтавокНДС.ВидСтавки(Выборка);
		СтавкиНДСОбъект.ДополнительныеСвойства.Вставить("ОбновлениеВидовСтавокНДС");
		
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СтавкиНДСОбъект);
		Исключение
			ТекстСообщения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации("ru='Ошибка заполнения вида ставки НДС'",
				УровеньЖурналаРегистрации.Ошибка,,
				СтавкиНДСОбъект.Ссылка,
				ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция СтавкаНДС(ВидСтавки, Период = Неопределено) Экспорт
	Если Период = Неопределено Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ВидСтавки = Перечисления.ВидыСтавокНДС.Общая Тогда
		Возврат ОбщаяСтавкаНДС(Период);
	ИначеЕсли ВидСтавки = Перечисления.ВидыСтавокНДС.ОбщаяРасчетная Тогда
		Возврат ОбщаяСтавкаНДС(Период, Истина);
	Иначе
		Возврат СтавкаНДСПоВидуСтавки(ВидСтавки);
	КонецЕсли
	
КонецФункции

Функция СтавкаНДСПоВидуСтавки(Знач ВидСтавки)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = &ВидСтавкиНДС";
	Запрос.УстановитьПараметр("ВидСтавкиНДС", ВидСтавки);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.СтавкиНДС.ПустаяСсылка();
	КонецЕсли;

КонецФункции

Функция ОбщаяСтавкаНДС(Знач Период, Расчетная = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК Ссылка,
	|	1 КАК Приоритет
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Общая)
	|	И СтавкиНДС.Ставка = &ЗначениеСтавки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка,
	|	2
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Общая)
	|	И СтавкиНДС.Ставка <> &ЗначениеСтавки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	Если Период >= Дата('20190101') Тогда
		Запрос.УстановитьПараметр("ЗначениеСтавки", 20);
	Иначе
		Запрос.УстановитьПараметр("ЗначениеСтавки", 18);
	КонецЕсли;
	Если Расчетная Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, ".Общая", ".ОбщаяРасчетная");
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.СтавкиНДС.ПустаяСсылка();
	КонецЕсли;
КонецФункции

Функция СоответствиеСтавокНДС(Период = Неопределено) Экспорт
	Если Период = Неопределено Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Результат = Новый Соответствие();
	Результат.Вставить(Перечисления.ВидыСтавокНДС.Общая, ОбщаяСтавкаНДС(Период));
	Результат.Вставить(Перечисления.ВидыСтавокНДС.ОбщаяРасчетная, ОбщаяСтавкаНДС(Период, Истина));
	
	МассивПеречислений = Новый Массив;
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.Пониженная);
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.ПониженнаяРасчетная);
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.Пониженная2);
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.ПониженнаяРасчетная2);
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.Нулевая);
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.БезНДС);
	
	Для Каждого ВидСтавки Из  МассивПеречислений Цикл
		Результат.Вставить(ВидСтавки,СтавкаНДСПоВидуСтавки(ВидСтавки));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьТекстЗапросаСозданияВТСтавкиНДС(Период = Неопределено) Экспорт
	Если Период = Неопределено Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК Ссылка,
	|	1 КАК Приоритет
	|ПОМЕСТИТЬ ВТСтавкиОбщая
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Общая)
	|	И СтавкиНДС.Ставка = &ЗначениеСтавки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка,
	|	2
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Общая)
	|	И СтавкиНДС.Ставка <> &ЗначениеСтавки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК Ссылка,
	|	1 КАК Приоритет
	|ПОМЕСТИТЬ ВТСтавкиОбщаяРасчетная
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.ОбщаяРасчетная)
	|	И СтавкиНДС.Ставка = &ЗначениеСтавки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка,
	|	2
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.ОбщаяРасчетная)
	|	И СтавкиНДС.Ставка <> &ЗначениеСтавки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВТСтавкиОбщая.Ссылка КАК СтавкаНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Общая) КАК ВидСтавкиНДС
	|ПОМЕСТИТЬ ВТСтавкиНДС
	|ИЗ
	|	ВТСтавкиОбщая КАК ВТСтавкиОбщая
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВТСтавкиОбщаяРасчетная.Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.ОбщаяРасчетная)
	|ИЗ
	|	ВТСтавкиОбщаяРасчетная КАК ВТСтавкиОбщаяРасчетная
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Пониженная)
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Пониженная)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.ПониженнаяРасчетная)
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.ПониженнаяРасчетная)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Нулевая)
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Нулевая)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.БезНДС)
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.БезНДС)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Пониженная2)
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Пониженная2)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.ПониженнаяРасчетная2)
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.ПониженнаяРасчетная2)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТСтавкиОбщая
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТСтавкиОбщаяРасчетная;";
	
	Если Период >= Дата('20190101') Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ЗначениеСтавки", "20");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ЗначениеСтавки", "18");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
КонецФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Параметры.Отбор.Вставить("ПометкаУдаления", Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли