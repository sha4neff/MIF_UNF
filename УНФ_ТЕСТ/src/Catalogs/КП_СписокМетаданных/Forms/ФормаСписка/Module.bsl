
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Список.РежимВыбора=ЭтаФорма.Параметры.РежимВыбора;
	
	Если Элементы.Список.РежимВыбора Тогда
		РежимОткрытияОкна=РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьСписокМетаданных(Команда)
	ОбновитьСписокСервером();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСервером()
	Справочники.КП_СписокМетаданных.ОбновитьСоставМетаданных();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияГруппаПримерыЗначенийОткрытьНажатие(Элемент)
	
	Элементы.ГруппаПримерыЗначений.Видимость=НЕ Элементы.ГруппаПримерыЗначений.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСправочникПользователиНажатие(Элемент)
	
	ИмяЭлемента="Справочник.Пользователи";
	
	НайденныйЭлемент=ПолучитьЭлементПоНаименованию(ИмяЭлемента);
	
	Если ЗначениеЗаполнено(НайденныйЭлемент) Тогда
		Закрыть(НайденныйЭлемент);
		
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Element was not found by name ""';ru='Внимание! Не найден элемент по имени ""'")+ИмяЭлемента+""".");
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСправочникРолеваяАдресацияНажатие(Элемент)
	
	ИмяЭлемента="Справочник.КП_РолеваяАдресация";
	
	НайденныйЭлемент=ПолучитьЭлементПоНаименованию(ИмяЭлемента);
	
	Если ЗначениеЗаполнено(НайденныйЭлемент) Тогда
		Закрыть(НайденныйЭлемент);
		
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Element was not found by name ""';ru='Внимание! Не найден элемент по имени ""'")+ИмяЭлемента+""".");
		Возврат;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьЭлементПоНаименованию(ИмяЭлемента)
	
	РезультатПоиска=Справочники.КП_СписокМетаданных.НайтиПоРеквизиту("ПолноеНаименование", ИмяЭлемента);
	
	Возврат РезультатПоиска;
	
КонецФункции

#КонецОбласти
