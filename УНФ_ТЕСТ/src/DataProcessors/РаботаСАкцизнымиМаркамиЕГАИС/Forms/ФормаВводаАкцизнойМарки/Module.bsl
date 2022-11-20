#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Параметры.ТекстОшибкиКонтроляАкцизныхМарок) Тогда
		Заголовок = НСтр("ru = 'Контроль акцизных марок'");
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрольАкцизныхМарок;
		
		Элементы.ТекстОшибкиКонтроляАкцизныхМарок.Заголовок = Параметры.ТекстОшибкиКонтроляАкцизныхМарок;
	Иначе
		Заголовок = НСтр("ru = 'Сканирование акцизной марки'");
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСканированиеАкцизнойМарки;
	КонецЕсли;
	
	Номенклатура          = Параметры.Номенклатура;
	Характеристика        = Параметры.Характеристика;
	ДанныеШтрихкода       = Параметры.ДанныеШтрихкода;
	
	ПараметрыСканирования     = ОбщегоНазначения.СкопироватьРекурсивно(Параметры.ПараметрыСканирования, Ложь);
	Если ЭтоАдресВременногоХранилища(ПараметрыСканирования.КэшМаркируемойПродукции) Тогда
		ДанныеКэша = ПолучитьИзВременногоХранилища(ПараметрыСканирования.КэшМаркируемойПродукции);
		КэшМаркируемойПродукции = ПоместитьВоВременноеХранилище(ДанныеКэша, УникальныйИдентификатор);
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСканированиеАкцизнойМарки Тогда
		ЭтотОбъект.ТекущийЭлемент = Элементы.СтраницаСканированиеАкцизнойМарки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрольАкцизныхМарок Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрольАкцизныхМарок Тогда
		Возврат;
	КонецЕсли;
	
	ДоработатьПараметрыСканирования();
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	
	СобытияФормИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(
		ОповещениеПриЗавершении, ЭтотОбъект,
		Источник, Событие, Данные, ПараметрыСканирования);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВвестиАкцизнуюМарку(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	Если ДанныеШтрихкода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеШтрихкода.ТипУпаковки <> ПредопределенноеЗначение("Перечисление.ТипыУпаковок.МаркированныйТовар") Тогда
		ВывестиСообщениеНаСтраницеВводаКодаМаркировки(
			НСтр("ru = 'Штрихкод не соответствует формату штрихкода акцизной марки'"));
		Возврат;
	ИначеЕсли ЗначениеЗаполнено(ДанныеШтрихкода.Номенклатура) И ДанныеШтрихкода.Номенклатура <> Номенклатура Тогда
		ВывестиСообщениеНаСтраницеВводаКодаМаркировки(
			СтрШаблон(НСтр("ru = 'Акцизная марка не соответствует номенклатуре %1'"), Номенклатура));
		Возврат;
	ИначеЕсли ЗначениеЗаполнено(ДанныеШтрихкода.ТекстОшибки) Тогда
		ВывестиСообщениеНаСтраницеВводаКодаМаркировки(ДанныеШтрихкода.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	ОбработатьШтрихкодАкцизнойМарки(ДанныеШтрихкода, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкодАкцизнойМарки(ДанныеШтрихкода, ДополнительныеПараметры)
	
	АдресРезультатаОбработкиШтрихкода = ПоместитьВоВременноеХранилище(ДанныеШтрихкода, УникальныйИдентификатор);
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСканированиеАкцизнойМарки Тогда
		ПодключитьОбработчикОжидания("ЗакрытьФормуПриСканировании", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуПриСканировании()
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультатаОбработкиШтрихкода);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоработатьПараметрыСканирования()
	
	Если ПараметрыСканирования = Неопределено Тогда
		ПараметрыСканирования = ШтрихкодированиеИСКлиент.ПараметрыСканирования(
			ВладелецФормы, ЭтотОбъект, ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная"));
	КонецЕсли;
	ПараметрыСканирования.КэшМаркируемойПродукции           = КэшМаркируемойПродукции;
	ПараметрыСканирования.СопоставлятьНоменклатуру          = Ложь;
	ПараметрыСканирования.РазрешеноЗапрашиватьКодМаркировки = Ложь;
	ПараметрыСканирования.ВыводитьСообщенияОбОшибках        = Ложь;
	ПараметрыСканирования.ИспользуетсяСоответствиеШтрихкодовСтрокДерева = Ложь;
	ПараметрыСканирования.ВозможнаЗагрузкаТСД               = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ДоработатьПараметрыСканирования();
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	
	ШтрихкодированиеИСКлиент.ОбработатьДанныеШтрихкода(
		ОповещениеПриЗавершении, ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканирования);
	
КонецПроцедуры

&НаСервере
Процедура ВывестиСообщениеНаСтраницеВводаКодаМаркировки(ТекстСообщения)
	
	ДобавитьЭлементДекорацияНаФорму();
	Элементы.ИнформацияВводаКодаМаркировки.Заголовок = ТекстСообщения;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементДекорацияНаФорму()
	
	ИмяЭлемента = "ИнформацияВводаКодаМаркировки";
	
	Если Элементы.Найти(ИмяЭлемента) = Неопределено Тогда
		Элементы.Добавить(ИмяЭлемента, Тип("ДекорацияФормы"), Элементы.ГруппаИнформация);
		Элементы.ИнформацияВводаКодаМаркировки.ЦветТекста = ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС;
	КонецЕсли;
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОткрытьФормуУточненияДанных()
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект);
	ШтрихкодированиеИСКлиент.Подключаемый_ОткрытьФормуУточненияДанных(ЭтотОбъект, ОповещениеПриЗавершении);
	
КонецПроцедуры

#КонецОбласти