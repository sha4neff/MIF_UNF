
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	РежимВыбора = Параметры.РежимВыбора;
	
	Элементы.СписокВыбратьИзСправочника.Видимость = РежимВыбора;
	Элементы.ВыбратьИзКлассификатора.Видимость = РежимВыбора;
	
	КлассификаторУпаковок.Загрузить(ИнтеграцияВЕТИСПовтИсп.Упаковки());
	ОпределитьНаличиеСсылокВБазе();
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_УпаковкиВЕТИС" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗагружено;
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = Параметр;
		ОпределитьНаличиеСсылокВБазе();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьИзСправочника(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзКлассификатора(Команда)
	ТекущиеДанные = Элементы.КлассификаторУпаковок.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.СсылкаВБазе) Тогда
		ОповеститьОВыборе(ТекущиеДанные.СсылкаВБазе);
	Иначе
		ОповеститьОВыборе(ЗагрузитьЭлементКлассификатора(ТекущиеДанные.Идентификатор, ТекущиеДанные.Код));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	ОпределитьНаличиеСсылокВБазе();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ПриСменеОсновнойСтраницы();
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторУпаковокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.КлассификаторУпаковок.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		ВыбратьИзКлассификатора(Неопределено);
	Иначе
		ПараметрыОткрытия = Новый Структура;
		Если ЗначениеЗаполнено(ТекущиеДанные.СсылкаВБазе) Тогда
			ПараметрыОткрытия.Вставить("Ключ", ТекущиеДанные.СсылкаВБазе);
		Иначе
			ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ТекущаяСтрокаСтруктурой(ТекущиеДанные));
		КонецЕсли;
		ОткрытьФорму("Справочник.УпаковкиВЕТИС.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьЭлементКлассификатора(ИдентификаторЭлемента, КодЭлемента)
	
	ЭлементДанных = Новый Структура("guid, globalID",
		ИдентификаторЭлемента, 
		КодЭлемента);
	Возврат ИнтеграцияВЕТИС.Упаковка(ЭлементДанных);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекущаяСтрокаСтруктурой(ТекущиеДанные)
	СтруктураЗаполнения = Новый Структура();
	СтруктураЗаполнения.Вставить("Наименование",  ТекущиеДанные.Наименование);
	СтруктураЗаполнения.Вставить("Идентификатор", ТекущиеДанные.Идентификатор);
	СтруктураЗаполнения.Вставить("КодЕЭК",        ТекущиеДанные.Код);
	
	Возврат СтруктураЗаполнения
	
КонецФункции

&НаКлиенте
Процедура ПриСменеОсновнойСтраницы()
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗагружено Тогда
		Элементы.СписокВыбратьИзСправочника.КнопкаПоУмолчанию = Истина;
		Элементы.ВыбратьИзКлассификатора.КнопкаПоУмолчанию    = Ложь;
	Иначе
		Элементы.СписокВыбратьИзСправочника.КнопкаПоУмолчанию = Ложь;
		Элементы.ВыбратьИзКлассификатора.КнопкаПоУмолчанию    = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОпределитьНаличиеСсылокВБазе()
	
	ТаблицаФормы = ЭтаФорма.КлассификаторУпаковок;
	Если ТаблицаФормы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивИдентификаторов = ТаблицаФормы.Выгрузить(, "Идентификатор").ВыгрузитьКолонку("Идентификатор");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	УпаковкиВЕТИС.Идентификатор КАК Идентификатор,
	|	УпаковкиВЕТИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.УпаковкиВЕТИС КАК УпаковкиВЕТИС
	|ГДЕ
	|	УпаковкиВЕТИС.Идентификатор В(&МассивИдентификаторов)";
	
	Запрос.УстановитьПараметр("МассивИдентификаторов", МассивИдентификаторов);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПараметрыПоиска = Новый Структура("Идентификатор");
	
	Пока Выборка.Следующий() Цикл
		
		ПараметрыПоиска.Идентификатор = Выборка.Идентификатор;
		
		НайденныеСтроки = ТаблицаФормы.НайтиСтроки(ПараметрыПоиска);
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.ЕстьВБазе = 1;
			НайденнаяСтрока.СсылкаВБазе = Выборка.Ссылка;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
