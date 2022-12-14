
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СписокЭлементов") Тогда
		Для Каждого ЭлементСписка Из Параметры.СписокЭлементов Цикл
			НоваяСтрока=ТаблицаЭлементов.Добавить();
			НоваяСтрока.ИмяЭлемента=ЭлементСписка.Значение;
			НоваяСтрока.Синоним=ЭлементСписка.Представление;
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаЭлементов.Сортировать("Синоним Возр");
	
	Если Параметры.Свойство("ИмяКнопкиВыбора") Тогда
		Элементы.СписокЭлементовВыбратьЭлемент.Заголовок=Параметры.ИмяКнопкиВыбора;
	КонецЕсли;
	
	Параметры.Свойство("РезультатТип", РезультатТип);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЭлемент(Команда)
	
	СтрокаТЧ=Элементы.ТаблицаЭлементов.ТекущиеДанные;
	
	Если СтрокаТЧ<>Неопределено Тогда
		СтруктураРезультата=Новый Структура("ВыбранныйЭлемент", СтрокаТЧ.ИмяЭлемента);
		СтруктураРезультата.Вставить("РезультатТип", РезультатТип);
		Оповестить("ЭлементСпискаВыбран", СтруктураРезультата);
	КонецЕсли;
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЭлементовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыбратьЭлемент(Неопределено);
	
КонецПроцедуры


