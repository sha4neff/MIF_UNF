#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ФормаПодобратьИзКлассификатора.Видимость = ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Справочники.ВидыМехаГИСМ);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВидыМехаГИСМ_ПодборИзКлассификатора" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ОткрытьФорму("Справочник.ВидыМехаГИСМ.Форма.ДобавлениеЭлементовВКлассификатор",, ЭтаФорма, , , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти
