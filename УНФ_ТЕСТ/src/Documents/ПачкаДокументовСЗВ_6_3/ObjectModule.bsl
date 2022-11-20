#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Проверка заполнения документа
// 
// Параметры:
// 	ПроверяемыеРеквизиты - Массив - .
// 	НеПроверяемыеРеквизиты - Массив - .
// 	Отказ - Булево - .
Процедура ПроверкаЗаполненияДокумента(ПроверяемыеРеквизиты, НеПроверяемыеРеквизиты, Отказ) Экспорт
	
	НаименованиеОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "Наименование");
	
	КоличествоДокументов = Сотрудники.Количество();
	Если КоличествоДокументов = 0 Тогда
		ТекстОшибки = НСтр("ru = 'Список застрахованных лиц пуст.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, , ,Отказ);
	КонецЕсли;
	Если КоличествоДокументов > 200 Тогда
		ТекстОшибки = ТекстОшибки = НСтр("ru = 'В документе должно быть не более 200 форм.'"); 
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, , ,Отказ);
	КонецЕсли;
	
	ВыборкаПоСтрокамДокумента = ПолучитьДанныеДляПроверки();
	
	Пока ВыборкаПоСтрокамДокумента.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ВыборкаПоСтрокамДокумента.СотрудникРаботаетВОрганизации Тогда
			ТекстОшибки = СтрШаблон(НСтр(
				"ru = 'Сотрудник %1 в течение отчетного периода не работал в организации %2'"),
				ВыборкаПоСтрокамДокумента.СотрудникНаименование, НаименованиеОрганизации);
				
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(
				ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник", , Отказ);
		КонецЕсли;
			
		// Контроль дубля строк
		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.НомерПовторяющейсяСтроки) Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Сотрудник %1 указан в документе дважды'"),
				ВыборкаПоСтрокамДокумента.СотрудникНаименование);
			СообщитьОбОшибкеВСтроке(ТекстОшибки, ВыборкаПоСтрокамДокумента.НомерСтроки, Отказ);
		ИначеЕсли ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.НомерПовторяющейсяСтрокиСтраховойНомер) Тогда
			ТекстОшибки = СтрШаблон(НСтр(
				"ru = 'Сотрудник %1: информация о сотруднике с таким же страховым номером была введена в документе ранее'"),
				ВыборкаПоСтрокамДокумента.СотрудникНаименование);
			СообщитьОбОшибкеВСтроке(ТекстОшибки, ВыборкаПоСтрокамДокумента.НомерСтроки, Отказ);
		КонецЕсли;

		Если Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ВсегоЗаработка) Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Сотрудник %1: отсутствуют данные о заработке'"),
				ВыборкаПоСтрокамДокумента.СотрудникНаименование);
			СообщитьОбОшибкеВСтроке(ТекстОшибки, ВыборкаПоСтрокамДокумента.НомерСтроки, Отказ);
		Иначе
			Если ВыборкаПоСтрокамДокумента.НаименьшийМесяц < 1 Тогда
				ТекстОшибки = СтрШаблон(НСтр("ru = 'Сотрудник %1: неверно указан один из месяцев - меньше 1'"),
					ВыборкаПоСтрокамДокумента.СотрудникНаименование);
				СообщитьОбОшибкеВСтроке(ТекстОшибки, ВыборкаПоСтрокамДокумента.НомерСтроки, Отказ);
			КонецЕсли;
			Если ВыборкаПоСтрокамДокумента.МинимальныйЗаработок < 0 Тогда
				ТекстОшибки = СтрШаблон(НСтр(
					"ru = 'Сотрудник %1: за один или несколько месяцев указан отрицательный заработок'"),
					ВыборкаПоСтрокамДокумента.СотрудникНаименование);
				СообщитьОбОшибкеВСтроке(ТекстОшибки, ВыборкаПоСтрокамДокумента.НомерСтроки, Отказ);
			КонецЕсли;
			Если ВыборкаПоСтрокамДокумента.МинимальныйОблагаетсяВзносами < 0 Тогда
				ТекстОшибки = СтрШаблон(НСтр(
					"ru = 'Сотрудник %1: за один или несколько месяцев указана отрицательная облагаемая сумма'"),
					ВыборкаПоСтрокамДокумента.СотрудникНаименование);
				СообщитьОбОшибкеВСтроке(ТекстОшибки, ВыборкаПоСтрокамДокумента.НомерСтроки, Отказ);
			КонецЕсли;
		КонецЕсли;
		Если ВыборкаПоСтрокамДокумента.НаибольшийМесяц > 12 Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Сотрудник %1: неверно указан один из месяцев, превышает 12'"),
				ВыборкаПоСтрокамДокумента.СотрудникНаименование);
			СообщитьОбОшибкеВСтроке(ТекстОшибки, ВыборкаПоСтрокамДокумента.НомерСтроки, Отказ);
		КонецЕсли;
		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ФизЛицоСДвойнымиМесяцами) Тогда
			ТекстОшибки = СтрШаблон(НСтр(
				"ru = 'Сотрудник %1: в данных о заработке один из месяцев повторяется несколько раз.'"),
				ВыборкаПоСтрокамДокумента.СотрудникНаименование);
			СообщитьОбОшибкеВСтроке(ТекстОшибки, ВыборкаПоСтрокамДокумента.НомерСтроки, Отказ);
		КонецЕсли;
		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ФизЛицоСНевернымиОблагаемымиСуммами) Тогда
			ТекстОшибки = СтрШаблон(НСтр(
				"ru = 'Сотрудник %1: в данных о заработке сумма, облагаемая взносами, превышает сумму начисленного заработка.'"),
				ВыборкаПоСтрокамДокумента.СотрудникНаименование);
			СообщитьОбОшибкеВСтроке(ТекстОшибки, ВыборкаПоСтрокамДокумента.НомерСтроки, Отказ);
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОтчетныйПериодДата = Дата(ОтчетныйПериод, 12, 31);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеДляПроверки()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	Запрос.УстановитьПараметр("СведенияОЗаработке", СведенияОЗаработке);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПачкаДокументовСЗВ_6_3Сотрудники.НомерСтроки,
	|	ПачкаДокументовСЗВ_6_3Сотрудники.Сотрудник,
	|	ПачкаДокументовСЗВ_6_3Сотрудники.СтраховойНомерПФР,
	|	ПачкаДокументовСЗВ_6_3Сотрудники.Фамилия,
	|	ПачкаДокументовСЗВ_6_3Сотрудники.Имя,
	|	ПачкаДокументовСЗВ_6_3Сотрудники.Отчество
	|ПОМЕСТИТЬ ВТЗастрахованныеЛица
	|ИЗ
	|	&Сотрудники КАК ПачкаДокументовСЗВ_6_3Сотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПачкаДокументовСЗВ_6_3СведенияОЗаработке.НомерСтроки,
	|	ПачкаДокументовСЗВ_6_3СведенияОЗаработке.Сотрудник,
	|	ПачкаДокументовСЗВ_6_3СведенияОЗаработке.Месяц,
	|	ПачкаДокументовСЗВ_6_3СведенияОЗаработке.Заработок,
	|	ПачкаДокументовСЗВ_6_3СведенияОЗаработке.ОблагаетсяВзносами
	|ПОМЕСТИТЬ ВТСтрокиЗаработкаЗастрахованных
	|ИЗ
	|	&СведенияОЗаработке КАК ПачкаДокументовСЗВ_6_3СведенияОЗаработке";
	
	Запрос.Выполнить();
	
	УчетСтраховыхВзносов.СформироватьТаблицуВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Организация, Дата(ОтчетныйПериод, 1, 1), КонецГода(Дата(ОтчетныйПериод, 1, 1)));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(СведенияОНачисленномЗаработкеСЗВ63СведенияОЗаработке.Месяц) КАК НаибольшийМесяц,
	|	МИНИМУМ(СведенияОНачисленномЗаработкеСЗВ63СведенияОЗаработке.Месяц) КАК НаименьшийМесяц,
	|	СУММА(СведенияОНачисленномЗаработкеСЗВ63СведенияОЗаработке.Заработок) КАК Заработок,
	|	СУММА(СведенияОНачисленномЗаработкеСЗВ63СведенияОЗаработке.ОблагаетсяВзносами) КАК ОблагаетсяВзносами,
	|	СведенияОНачисленномЗаработкеСЗВ63СведенияОЗаработке.Сотрудник,
	|	МИНИМУМ(СведенияОНачисленномЗаработкеСЗВ63СведенияОЗаработке.Заработок) КАК МинимальныйЗаработок,
	|	МИНИМУМ(СведенияОНачисленномЗаработкеСЗВ63СведенияОЗаработке.ОблагаетсяВзносами) КАК МинимальныйОблагаетсяВзносами
	|ПОМЕСТИТЬ ВТЗаработокЗастрахованных
	|ИЗ
	|	ВТСтрокиЗаработкаЗастрахованных КАК СведенияОНачисленномЗаработкеСЗВ63СведенияОЗаработке
	|
	|СГРУППИРОВАТЬ ПО
	|	СведенияОНачисленномЗаработкеСЗВ63СведенияОЗаработке.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПерваяТаблица.Сотрудник
	|ПОМЕСТИТЬ ВТДвойныеМесяцы
	|ИЗ
	|	ВТСтрокиЗаработкаЗастрахованных КАК ПерваяТаблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСтрокиЗаработкаЗастрахованных КАК ВтораяТаблица
	|		ПО ПерваяТаблица.Сотрудник = ВтораяТаблица.Сотрудник
	|			И ПерваяТаблица.Месяц = ВтораяТаблица.Месяц
	|			И ПерваяТаблица.НомерСтроки <> ВтораяТаблица.НомерСтроки
	|ГДЕ
	|	ВтораяТаблица.НомерСтроки ЕСТЬ НЕ NULL 
	|
	|СГРУППИРОВАТЬ ПО
	|	ПерваяТаблица.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПерваяТаблица.Сотрудник
	|ПОМЕСТИТЬ ВТНеверныеОблагаемыеСуммы
	|ИЗ
	|	ВТСтрокиЗаработкаЗастрахованных КАК ПерваяТаблица
	|ГДЕ
	|	ПерваяТаблица.Заработок < ПерваяТаблица.ОблагаетсяВзносами
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ВтораяТаблица.НомерСтроки) КАК НомерПовторяющейсяСтроки,
	|	ПерваяТаблица.Сотрудник,
	|	ПерваяТаблица.НомерСтроки КАК НомерСтроки,
	|	ПерваяТаблица.СтраховойНомерПФР,
	|	ПерваяТаблица.Фамилия,
	|	ПерваяТаблица.Имя,
	|	ПерваяТаблица.Отчество,
	|	ДанныеСотрудников.Наименование КАК СотрудникНаименование,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеСотрудниками.ФизическоеЛицо ЕСТЬ НЕ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СотрудникРаботаетВОрганизации,
	|	ДвойныеМесяцы.Сотрудник КАК ФизЛицоСДвойнымиМесяцами,
	|	ЕСТЬNULL(ЗаработокЗастрахованных.НаибольшийМесяц, 12) КАК НаибольшийМесяц,
	|	ЕСТЬNULL(ЗаработокЗастрахованных.Заработок, 0) КАК ВсегоЗаработка,
	|	ЕСТЬNULL(ЗаработокЗастрахованных.ОблагаетсяВзносами, 0) КАК ВсегоОблагаетсяВзносами,
	|	ЕСТЬNULL(ЗаработокЗастрахованных.НаименьшийМесяц, 0) КАК НаименьшийМесяц,
	|	ЕСТЬNULL(ЗаработокЗастрахованных.МинимальныйЗаработок, 0) КАК МинимальныйЗаработок,
	|	ЕСТЬNULL(ЗаработокЗастрахованных.МинимальныйОблагаетсяВзносами, 0) КАК МинимальныйОблагаетсяВзносами,
	|	НеверныеОблагаемыеСуммы.Сотрудник КАК ФизЛицоСНевернымиОблагаемымиСуммами,
	|	МИНИМУМ(ДублиСтраховыеНомера.НомерСтроки) КАК НомерПовторяющейсяСтрокиСтраховойНомер
	|ИЗ
	|	ВТЗастрахованныеЛица КАК ПерваяТаблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ДанныеСотрудников
	|		ПО ПерваяТаблица.Сотрудник = ДанныеСотрудников.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК ЗарегистрированныеСотрудниками
	|		ПО ПерваяТаблица.Сотрудник = ЗарегистрированныеСотрудниками.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗастрахованныеЛица КАК ВтораяТаблица
	|		ПО ПерваяТаблица.Сотрудник = ВтораяТаблица.Сотрудник
	|			И ПерваяТаблица.НомерСтроки > ВтораяТаблица.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаработокЗастрахованных КАК ЗаработокЗастрахованных
	|		ПО ПерваяТаблица.Сотрудник = ЗаработокЗастрахованных.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДвойныеМесяцы КАК ДвойныеМесяцы
	|		ПО ПерваяТаблица.Сотрудник = ДвойныеМесяцы.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНеверныеОблагаемыеСуммы КАК НеверныеОблагаемыеСуммы
	|		ПО ПерваяТаблица.Сотрудник = НеверныеОблагаемыеСуммы.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗастрахованныеЛица КАК ДублиСтраховыеНомера
	|		ПО ПерваяТаблица.НомерСтроки > ДублиСтраховыеНомера.НомерСтроки
	|			И ПерваяТаблица.СтраховойНомерПФР = ДублиСтраховыеНомера.СтраховойНомерПФР
	|			И ПерваяТаблица.Сотрудник <> ДублиСтраховыеНомера.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	ПерваяТаблица.Сотрудник,
	|	ПерваяТаблица.НомерСтроки,
	|	ПерваяТаблица.СтраховойНомерПФР,
	|	ПерваяТаблица.Фамилия,
	|	ПерваяТаблица.Имя,
	|	ПерваяТаблица.Отчество,
	|	ДанныеСотрудников.Наименование,
	|	ВЫБОР
	|		КОГДА ЗарегистрированныеСотрудниками.ФизическоеЛицо ЕСТЬ НЕ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ,
	|	ЗаработокЗастрахованных.ОблагаетсяВзносами,
	|	ДвойныеМесяцы.Сотрудник,
	|	НеверныеОблагаемыеСуммы.Сотрудник,
	|	ЗаработокЗастрахованных.МинимальныйЗаработок,
	|	ЗаработокЗастрахованных.МинимальныйОблагаетсяВзносами,
	|	ЕСТЬNULL(ЗаработокЗастрахованных.НаибольшийМесяц, 12),
	|	ЕСТЬNULL(ЗаработокЗастрахованных.Заработок, 0),
	|	ЕСТЬNULL(ЗаработокЗастрахованных.НаименьшийМесяц, 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	Возврат Запрос.Выполнить().Выбрать();			  	
	
КонецФункции	

Процедура СообщитьОбОшибкеВСтроке(ТекстСообщения, НомерСтроки, Отказ)
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, СтрШаблон(
		"Объект.Сотрудники[%1].Сотрудник", XMLСтрока(НомерСтроки - 1)), , Отказ);
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли