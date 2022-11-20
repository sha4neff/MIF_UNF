
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокТипов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипыОснованийЗадачиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьТипОснования();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьТипОснования();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокТипов()
	
	ТипыОснованийЗадачиМассив = Метаданные.ОпределяемыеТипы.ОснованиеЗадачи.Тип.Типы();
	Для каждого ТипОснования Из ТипыОснованийЗадачиМассив Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипОснования);
		Если Не ПравоДоступа("Редактирование", ОбъектМетаданных) Тогда
			Продолжить;
		КонецЕсли;
		ТипыОснованийЗадачи.Добавить(ТипОснования, ОбъектМетаданных.Представление());
	КонецЦикла;
	
	ТипыОснованийЗадачи.СортироватьПоПредставлению();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТипОснования()
	
	Закрыть(Элементы.ТипыОснованийЗадачи.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

