#Область СлужебныеПроцедурыИФункции

// Функция формирует и возвращает строку описания результата
// Параметры:
//		ОтчетОбъект - содержит объект для которого формируется строка
// Возвращаемое значение: Строка
Функция СформироватьОписаниеРезультата(ОтчетОбъект) Экспорт
	
	Если КП_ЗадачиПроцессов.ТребуемыйРезультатПроизвольныйОтчет(ОтчетОбъект) Тогда
		СтрокаРезультатаНачало="Требуется результат в произвольном виде";
		СтрокаРезультата=".";
		ВозможенПроизвольныйРезультат=Истина;
		
	Иначе
		СтрокаРезультатаНачало="Требуется предоставить результат в виде ";
		СтрокаРезультата="";
		ВозможенПроизвольныйРезультат=Ложь;
		
	КонецЕсли;
		
	ТребуетсяРезультатТекст=КП_ЗадачиПроцессов.ТребуемыйРезультатТекст(ОтчетОбъект);
	Если ТребуетсяРезультатТекст Тогда
		СтрокаРезультата=СтрокаРезультата+?(СтрокаРезультата="", "", ", ")+"текстового отчета";
	КонецЕсли;
	
	ТребуетсяРезультатБулево=КП_ЗадачиПроцессов.ТребуемыйРезультатБулево(ОтчетОбъект);
	Если ТребуетсяРезультатБулево Тогда
		СтрокаРезультата=СтрокаРезультата+?(СтрокаРезультата="", "", ", ")+"принятия решения (да/нет)";
	КонецЕсли;
	
	ТребуетсяРезультатФайл=КП_ЗадачиПроцессов.ТребуемыйРезультатФайл(ОтчетОбъект);
	Если ТребуетсяРезультатФайл Тогда
		СтрокаРезультата=СтрокаРезультата+?(СтрокаРезультата="", "", ", ")+"файла с отчетом";
	КонецЕсли;
	
	ТребуетсяРезультатДокумент=КП_ЗадачиПроцессов.ТребуемыйРезультатДокумент(ОтчетОбъект);
	Если ТребуетсяРезультатДокумент Тогда
		СтрокаРезультата=СтрокаРезультата+?(СтрокаРезультата="", "", ", ")+"подготовленного документа";
	КонецЕсли;
	
	ТребуетсяРезультатЛичнаяВстреча=КП_ЗадачиПроцессов.ТребуемыйРезультатЛичнаяВстреча(ОтчетОбъект);
	Если ТребуетсяРезультатЛичнаяВстреча Тогда
		СтрокаРезультата=СтрокаРезультата+?(СтрокаРезультата="", "", ", ")+"личной встречи";
	КонецЕсли;
	
	ТребуетсяРезультатТелефонныйЗвонок=КП_ЗадачиПроцессов.ТребуемыйРезультатТелефонныйОтчет(ОтчетОбъект);
	Если ТребуетсяРезультатТелефонныйЗвонок Тогда
		СтрокаРезультата=СтрокаРезультата+?(СтрокаРезультата="", "", ", ")+"телефонного отчета";
	КонецЕсли;
	
	ТребуетсяРезультатЧисло=КП_ЗадачиПроцессов.ТребуемыйРезультатЧисло(ОтчетОбъект);
	Если ТребуетсяРезультатЛичнаяВстреча Тогда
		СтрокаРезультата=СтрокаРезультата+?(СтрокаРезультата="", "", ", ")+"указания числа";
	КонецЕсли;
	
	ТребуетсяРезультатДата=КП_ЗадачиПроцессов.ТребуемыйРезультатДата(ОтчетОбъект);
	Если ТребуетсяРезультатЛичнаяВстреча Тогда
		СтрокаРезультата=СтрокаРезультата+?(СтрокаРезультата="", "", ", ")+"указания даты";
	КонецЕсли;
	
	//соберем строку
	СтрокаТребуемогоРезультата=СтрокаРезультатаНачало+СтрокаРезультата;
	
	Если Прав(СтрокаТребуемогоРезультата, 1)<>"." Тогда
		СтрокаТребуемогоРезультата=СтрокаТребуемогоРезультата+".";
	КонецЕсли;
	
	Возврат СтрокаТребуемогоРезультата;
	
КонецФункции

// Процедура выполняет заполнение списка видов результатов
// Параметры:
//	Объект - ссылка на объект
Процедура ЗаполнитьСписокВидов(Объект) Экспорт
	
	Объект.ВидыОтчетов.Очистить();
		
	НоваяСтрока=Объект.ВидыОтчетов.Добавить();
	НоваяСтрока.ВидОтчета=ПланыВидовХарактеристик.КП_РезультатыИсполнителейЗадач.ТекстовоеСообщение;
	НоваяСтрока.НаименованиеРеквизитаВида="Описание результата";
	НоваяСтрока.Использование=Истина;
	
	НоваяСтрока=Объект.ВидыОтчетов.Добавить();
	НоваяСтрока.ВидОтчета=ПланыВидовХарактеристик.КП_РезультатыИсполнителейЗадач.ТелефонныйОтчет;
	НоваяСтрока.НаименованиеРеквизитаВида=СокрЛП(НоваяСтрока.ВидОтчета);
	НоваяСтрока.Использование=Ложь;
		
	НоваяСтрока=Объект.ВидыОтчетов.Добавить();
	НоваяСтрока.ВидОтчета=ПланыВидовХарактеристик.КП_РезультатыИсполнителейЗадач.ВыборКнопками;
	НоваяСтрока.НаименованиеРеквизитаВида="Одобрить | Отклонить";
	НоваяСтрока.Использование=Ложь;
	
	НоваяСтрока=Объект.ВидыОтчетов.Добавить();
	НоваяСтрока.ВидОтчета=ПланыВидовХарактеристик.КП_РезультатыИсполнителейЗадач.ЛичнаяВстреча;
	НоваяСтрока.НаименованиеРеквизитаВида=СокрЛП(НоваяСтрока.ВидОтчета);
	НоваяСтрока.Использование=Ложь;
	
	НоваяСтрока=Объект.ВидыОтчетов.Добавить();
	НоваяСтрока.ВидОтчета=ПланыВидовХарактеристик.КП_РезультатыИсполнителейЗадач.ПриложенныйДокумент;
	НоваяСтрока.НаименованиеРеквизитаВида="Подготовленный документ";
	НоваяСтрока.Использование=Ложь;
	
	НоваяСтрока=Объект.ВидыОтчетов.Добавить();
	НоваяСтрока.ВидОтчета=ПланыВидовХарактеристик.КП_РезультатыИсполнителейЗадач.РезультатЧисло;
	НоваяСтрока.НаименованиеРеквизитаВида="Числовой результат";
	НоваяСтрока.Использование=Ложь;

	НоваяСтрока=Объект.ВидыОтчетов.Добавить();
	НоваяСтрока.ВидОтчета=ПланыВидовХарактеристик.КП_РезультатыИсполнителейЗадач.РезультатДата;
	НоваяСтрока.НаименованиеРеквизитаВида="Результат дата/время";
	НоваяСтрока.Использование=Ложь;
	
	НоваяСтрока=Объект.ВидыОтчетов.Добавить();
	НоваяСтрока.ВидОтчета=ПланыВидовХарактеристик.КП_РезультатыИсполнителейЗадач.БулевыйРезультат;
	НоваяСтрока.НаименованиеРеквизитаВида="Результат (да/нет)";
	НоваяСтрока.Использование=Ложь;
		
КонецПроцедуры

#КонецОбласти
