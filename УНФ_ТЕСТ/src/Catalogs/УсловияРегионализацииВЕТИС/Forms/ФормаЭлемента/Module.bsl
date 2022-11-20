#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ЗаболеванияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Заболевания.ТекущиеДанные;
	
	Если Поле.Имя = "ЗаболеванияЗаболевание" Тогда
		СтандартнаяОбработка = Ложь;
		
		Заболевание = ТекущиеДанные.Заболевание;
		Если ЗначениеЗаполнено(Заболевание) Тогда
			ПараметрыОткрываемойФормы = Новый Структура;
			ПараметрыОткрываемойФормы.Вставить("Ключ", Заболевание);
			ОткрытьФорму("Справочник.ЗаболеванияВЕТИС.ФормаОбъекта", ПараметрыОткрываемойФормы,,УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
