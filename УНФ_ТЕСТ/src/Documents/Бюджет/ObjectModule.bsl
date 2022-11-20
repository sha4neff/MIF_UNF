#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимНаправлениямДеятельности.Получить() Тогда
		
		Для каждого СтрокаДоходы Из Доходы Цикл
			
			Если СтрокаДоходы.Счет.ТипСчета = Перечисления.ТипыСчетов.ПрочиеДоходы Тогда
				СтрокаДоходы.НаправлениеДеятельности = Справочники.НаправленияДеятельности.Прочее;
			Иначе
				СтрокаДоходы.НаправлениеДеятельности = Справочники.НаправленияДеятельности.ОсновноеНаправление;
			КонецЕсли;
			
		КонецЦикла;
		
		Для каждого СтрокаРасходы Из Расходы Цикл
			
			Если СтрокаРасходы.Счет.ТипСчета = Перечисления.ТипыСчетов.ПрочиеРасходы
				ИЛИ СтрокаРасходы.Счет.ТипСчета = Перечисления.ТипыСчетов.ПроцентыПоКредитам Тогда
				СтрокаРасходы.НаправлениеДеятельности = Справочники.НаправленияДеятельности.Прочее;
			Иначе
				СтрокаРасходы.НаправлениеДеятельности = Справочники.НаправленияДеятельности.ОсновноеНаправление;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для каждого СтрокаДоходы Из Доходы Цикл
	
		Если СтрокаДоходы.Счет.ТипСчета = Перечисления.ТипыСчетов.Доходы Тогда
			
			Если НЕ ЗначениеЗаполнено(СтрокаДоходы.СтруктурнаяЕдиница) Тогда
				
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					ЭтотОбъект, 
					"В строке не указано подразделение. Для доходов по основным видам деятельности заполнение обязательно.",
					"Доходы",
					СтрокаДоходы.НомерСтроки,
					"СтруктурнаяЕдиница",
					Отказ
				);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если СтрокаДоходы.Счет.ТипСчета = Перечисления.ТипыСчетов.ПрочиеДоходы Тогда
			
			Если ЗначениеЗаполнено(СтрокаДоходы.НаправлениеДеятельности) И (СтрокаДоходы.НаправлениеДеятельности <> Справочники.НаправленияДеятельности.Прочее) Тогда
				
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					ЭтотОбъект, 
					"В строке указано направление деятельности отличное от 'Прочее'. Для прочих доходов требуется указание прочего вида деятельности.",
					"Доходы",
					СтрокаДоходы.НомерСтроки,
					"НаправлениеДеятельности",
					Отказ
				);
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаДоходы.СтруктурнаяЕдиница) Тогда
				
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					ЭтотОбъект, 
					"В строке указано подразделение. Для доходов по прочим видам деятельности заполнение не требуется.",
					"Доходы",
					СтрокаДоходы.НомерСтроки,
					"СтруктурнаяЕдиница",
					Отказ
				);
				
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЦикла;
	
	Для каждого СтрокаРасходы Из Расходы Цикл
		
		Если СтрокаРасходы.Счет.ТипСчета = Перечисления.ТипыСчетов.ПрочиеРасходы
		 ИЛИ СтрокаРасходы.Счет.ТипСчета = Перечисления.ТипыСчетов.ПроцентыПоКредитам Тогда
			
			Если НЕ ЗначениеЗаполнено(СтрокаРасходы.НаправлениеДеятельности) Тогда
				
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					"В строке не указано направление деятельности.",
					"Расходы",
					СтрокаРасходы.НомерСтроки,
					"НаправлениеДеятельности",
					Отказ
				);
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаРасходы.НаправлениеДеятельности) И (СтрокаРасходы.НаправлениеДеятельности <> Справочники.НаправленияДеятельности.Прочее) Тогда
				
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					"В строке указано направление деятельности отличное от 'Прочее'. Для прочих расходов требуется указание прочего вида деятельности.",
					"Расходы",
					СтрокаРасходы.НомерСтроки,
					"НаправлениеДеятельности",
					Отказ
				);
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаРасходы.СтруктурнаяЕдиница) Тогда
				
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					ЭтотОбъект, 
					"В строке указано подразделение. Для расходов по прочим видам деятельности заполнение не требуется.",
					"Расходы",
					СтрокаРасходы.НомерСтроки,
					"СтруктурнаяЕдиница",
					Отказ
				);
				
			КонецЕсли;
			
		Иначе
			
		КонецЕсли;
		
		Если СтрокаРасходы.Счет.ТипСчета = Перечисления.ТипыСчетов.СебестоимостьПродаж Тогда
			
			Если Константы.ФункциональнаяОпцияУчетПоНесколькимНаправлениямДеятельности.Получить() И
				(НЕ ЗначениеЗаполнено(СтрокаРасходы.НаправлениеДеятельности) ИЛИ (СтрокаРасходы.НаправлениеДеятельности = Справочники.НаправленияДеятельности.Прочее)) Тогда
				
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					"В строке не указано основное направление деятельности. Для себестоимости продаж требуется указание основного вида деятельности.",
					"Расходы",
					СтрокаРасходы.НомерСтроки,
					"НаправлениеДеятельности",
					Отказ
				);
				
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(СтрокаРасходы.СтруктурнаяЕдиница) Тогда
				
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					ЭтотОбъект, 
					"В строке не указано подразделение. Для себестоимости продаж по основным видам деятельности заполнение обязательно.",
					"Расходы",
					СтрокаРасходы.НомерСтроки,
					"СтруктурнаяЕдиница",
					Отказ
				);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.Бюджет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	УправлениеНебольшойФирмойСервер.ОтразитьДенежныеСредстваПрогноз(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДвиженияДенежныхСредств(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыПрогноз(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьФинансовыйРезультатПрогноз(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Добавляет дополнительные реквизиты, необходимые для проведения документа в
// переданную структуру.
//
// Параметры:
//  СтруктураДополнительныеСвойства - Структура дополнительных свойств документа.
//
Процедура ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения(СтруктураДополнительныеСвойства)
	
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("СценарийПланирования", СценарийПланирования);
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("Периодичность", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СценарийПланирования, "Периодичность"));
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ДатаНачала", ДатаНачала);
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ДатаОкончания", ДатаОкончания);
	
КонецПроцедуры // ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли