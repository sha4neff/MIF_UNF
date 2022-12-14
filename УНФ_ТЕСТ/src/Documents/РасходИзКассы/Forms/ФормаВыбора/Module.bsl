#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	
	// Для создания расхода из кассы с видом операции "Подотчетнтику" из авансового отчета.
	Если Параметры.Свойство("ВидОперацииКасса") Тогда
		Параметры.Отбор.Вставить("ВидОперации", Параметры.ВидОперацииКасса);
	КонецЕсли;
	
	Если Параметры.Свойство("ОрганизацияДляОтбора") И НЕ Константы.УчетПоКомпании.Получить() Тогда
		Параметры.Отбор.Вставить("Организация", Параметры.ОрганизацияДляОтбора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти