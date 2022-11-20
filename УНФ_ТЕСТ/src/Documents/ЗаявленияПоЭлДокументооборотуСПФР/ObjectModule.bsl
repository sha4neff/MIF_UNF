#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ПриЗаписиОбъекта(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ЗаполнитьНаименование();
	
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ВходящийКонтекст)
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ОбработкаЗаполненияОбъекта(ЭтотОбъект, ВходящийКонтекст);
	
	Если ТипЗнч(ВходящийКонтекст) = Тип("Структура") Тогда
	
		Если ВходящийКонтекст.Свойство("Организация") 
			И ЗначениеЗаполнено(ВходящийКонтекст.Организация) Тогда
			Организация = ВходящийКонтекст.Организация;
		КонецЕсли;
		
		Если ВходящийКонтекст.Свойство("Вид") 
			И ЗначениеЗаполнено(ВходящийКонтекст.Вид) Тогда
			Вид = ВходящийКонтекст.Вид;
		КонецЕсли;

		Если ВходящийКонтекст.Свойство("Основание")
			И ТипЗнч(ВходящийКонтекст.Основание) = Тип("ДокументСсылка.ЗаявлениеАбонентаСпецоператораСвязи") Тогда
		
			Основание = ВходящийКонтекст.Основание;
			ЗаполнитьНаОсновеЗаявленияПо1СОтчетности(Основание);
			ЗаполнитьНаОсновеСертификата(Основание); // заполняет только недостающие
			ЗаполнитьИзБазы(Основание.Организация); // заполняет только недостающие
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Организация) Тогда
			ЗаполнитьИзБазы(Организация); // заполняет только недостающие
		КонецЕсли;
		
	Иначе
		
		Если НЕ ЗначениеЗаполнено(Организация) 
			И РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
			Модуль 		= ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
			Организация = Модуль.ОрганизацияПоУмолчанию();
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Вид) И ЗначениеЗаполнено(Организация) 
		И Вид = Перечисления.ВидыЗаявленийНаЭДОВПФР.НаСертификат Тогда
		
		Если ТипЗнч(ВходящийКонтекст) = Тип("Структура")
			И ВходящийКонтекст.Свойство("Отпечаток")
			И ВходящийКонтекст.Свойство("ДвДанныеСертификата") Тогда
			
			ДвДанныеСертификата = ВходящийКонтекст.ДвДанныеСертификата;
			Отпечаток           = ВходящийКонтекст.Отпечаток;
			
		КонецЕсли;
		
		Сертификат = Новый ХранилищеЗначения(ДвДанныеСертификата);
		
	КонецЕсли;
	
	Оператор = Документы.ЗаявленияПоЭлДокументооборотуСПФР.ПараметрыЗаполненияОператора(Организация, Вид);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Оператор);
	
	Дата = МестноеВремя(ТекущаяДатаСеанса(), ЧасовойПоясСеанса());
	
	ПометкаУдаления = Ложь;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = ТекущаяДатаСеанса();
	ПометкаУдаления = Ложь;
	Получатель = Документы.ЗаявленияПоЭлДокументооборотуСПФР.ПолучательЗаявления(Организация);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Вид = Перечисления.ВидыЗаявленийНаЭДОВПФР.НаСертификат Тогда
		ИсключитьЛишниеРеквизитыДляСертификата(Отказ, ПроверяемыеРеквизиты);
		ПроверитьСертификат(Отказ);
	Иначе
		
		КонтекстЭДОСервер     = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
		ДействуетФорматАФ245д = КонтекстЭДОСервер.ДействуетФорматАФ245д();

		Если ЗначениеЗаполнено(Организация) Тогда
			
			ЭтоЮридическоеЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Организация);
			Если ЭтоЮридическоеЛицо Тогда
				ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("СНИЛС"));
			Иначе
				ИсключитьЛишниеРеквизитыДляИП(Отказ, ПроверяемыеРеквизиты);
			КонецЕсли;
			
			ПроверитьИНН("ИНН", Отказ, ЭтоЮридическоеЛицо);
			ПроверитьКПП("КПП", Отказ, ЭтоЮридическоеЛицо);
			ПроверитьРегНомерПФР("РегНомерПФР", Отказ);
			
			Если ДействуетФорматАФ245д Тогда
				ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("АдресРегистрации"));
				ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("АдресФактический"));
			Иначе
				ПроверитьАдрес(Отказ, АдресРегистрации, "Объект.АдресРегистрации", НСтр("ru = 'адрес регистрации'"));
				ПроверитьАдрес(Отказ, АдресФактический, "Объект.АдресФактический", НСтр("ru = 'фактический адрес'"));
			КонецЕсли;
			
		КонецЕсли;
		
		ПроверитьСНИЛС(Отказ);
		ПроверитьТелефон(Отказ);
		ПроверитьЭлПочту(Отказ);
		ПроверитьОператора(Отказ, ПроверяемыеРеквизиты, ДействуетФорматАФ245д);
		ПроверитьУчетку(Отказ);
		
	КонецЕсли;
	
	ПроверитьПолучателя(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПолучателя(Отказ)
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Получатель";

	Если ЗначениеЗаполнено(Организация) Тогда
		
		КодОрганаПФР = "";
		КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
		КонтекстЭДОСервер.ОпределитьОрганПФРОрганизации(Организация, КодОрганаПФР);
		
		Если НЕ ЗначениеЗаполнено(Получатель) Тогда
			
			Если ЗначениеЗаполнено(КодОрганаПФР) Тогда
				
				УчетнаяЗапись = КонтекстЭДОСервер.УчетнаяЗаписьОрганизации(Организация);
				Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
					
					ПолучательПоКоду = Справочники.ОрганыПФР.НайтиПоКоду(КодОрганаПФР);
					
					Если НЕ ЗначениеЗаполнено(ПолучательПоКоду) Тогда
						
						РезультатПроверки.ТекстОшибки = "Направление ПФР " + КодОрганаПФР + " не подключено. ";
						Если УчетнаяЗапись.СпецОператорСвязи = Перечисления.СпецоператорыСвязи.КалугаАстрал Тогда
							РезультатПроверки.ТекстОшибки = РезультатПроверки.ТекстОшибки + "Для подключения направления отправьте заявление на подключение направления 1С-Отчетности";
						Иначе
							РезультатПроверки.ТекстОшибки = РезультатПроверки.ТекстОшибки + "Для подключения направления обратитесь к своему оператору эл. документооборота";
						КонецЕсли;
						
					КонецЕсли;

				Иначе
					РезультатПроверки.ТекстОшибки = "Для отправки заявления подключите 1С-Отчетность";
				КонецЕсли;
					
			Иначе
				РезультатПроверки.ТекстОшибки = "Укажите код органа ПФР в карточке организации";
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецПроцедуры

Процедура ПроверитьОператора(Отказ, ПроверяемыеРеквизиты, ДействуетФорматАФ245д)
	
	Если Вид = Перечисления.ВидыЗаявленийНаЭДОВПФР.НаПодключение Тогда
		ПроверитьИНН("ОператорИНН", Отказ, Истина);
		ПроверитьКПП("ОператорКПП", Отказ, Истина);
		ПроверитьРегНомерПФР("ОператорРегНомерПФР", Отказ);
		
		Если ДействуетФорматАФ245д Тогда
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорНаименованиеПолное"));
		КонецЕсли;
		
	Иначе
		ИсключитьЛишниеРеквизитыОператора(Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

Процедура ИсключитьЛишниеРеквизитыОператора(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорРегНомерПФР"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорНаименованиеКраткое"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорНаименованиеПолное"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорИНН"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорКПП"));
	
КонецПроцедуры

Процедура ЗаполнитьНаОсновеЗаявленияПо1СОтчетности(Основание)
	
	Организация = Основание.Организация;
	АдресРегистрации = Основание.АдресЮридический;
	АдресФактический = Основание.АдресФактический;
	ИНН = Основание.ИНН;
	Получатель = Документы.ЗаявленияПоЭлДокументооборотуСПФР.ПолучательЗаявления(Организация);
	РегНомерПФР = Основание.РегНомерПФР; 
	ЭтоЮридическоеЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Организация);
	НаименованиеКраткое = Основание.КраткоеНаименование;
	КПП = Основание.КПП;
	// НаименованиеПолное - здесь нет заполнения полного наименования, потому что оно не хранится в заявлении по 1С-Отчетности
	Фамилия = Основание.ВладелецЭЦПФамилия;
	Имя = Основание.ВладелецЭЦПИмя;
	Отчество = Основание.ВладелецЭЦПОтчество;
	СНИЛС = Основание.ВладелецЭЦПСНИЛС;
	
	Если ЭтоЮридическоеЛицо Тогда
		Должность = Основание.ВладелецЭЦПДолжность;
	КонецЕсли;
		
	Телефон = Основание.ТелефонМобильный;
	ЭлектроннаяПочта = Основание.ЭлектроннаяПочта;

КонецПроцедуры

Процедура ЗаполнитьНаОсновеСертификата(Основание)
	
	// При включении сертификата это сертификат используется для подписания
	// В случае, если используется сертификат для подписания, из него уже будут взяты следующие реквизиты и заполнены в заявлении:
	// - Краткое наименование
	// - Должность
	// - Электронная почта
	// Поэтому эти поля не достаем из сертификата
	// Так же не все реквизиты заявления есть в сертификате.
	// Можно получить только следующие реквизиты:
	// - Фамилия
	// - Имя
	// - Отчество
	// - СНИЛС
	// - ИНН
	
	Сертификат = Основание.РеквизитыСертификата.Получить();
	Если ТипЗнч(Сертификат) = Тип("Структура") Тогда
	
		Если Сертификат.Свойство("ВладелецСтруктура") Тогда
			ВладелецСтруктура = Сертификат.ВладелецСтруктура;
		ИначеЕсли Сертификат.Свойство("Субъект") Тогда
			ВладелецСтруктура = Сертификат.Субъект;
		Иначе
			Возврат;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ИНН) Тогда
			ЭтоЮридическоеЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Основание.Организация);
			ИНН = ВладелецСтруктура.INN;
			Если ЭтоЮридическоеЛицо Тогда
				// Обрезаем первые 2 нуля в 009616091403
				ИНН = Сред(ИНН, 3);
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СНИЛС) Тогда
			СНИЛС = ВладелецСтруктура.SNILS;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Фамилия) Тогда
			Фамилия = ВладелецСтруктура.SN;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Имя) ИЛИ НЕ ЗначениеЗаполнено(Отчество) Тогда
			
			ИмяОтчество = ВладелецСтруктура.GN;
			Позиция = СтрНайти(ИмяОтчество, " ");
			Если Позиция > 0 Тогда
				Имя = Сред(ИмяОтчество, 1, Позиция-1);
				Отчество = Сред(ИмяОтчество, Позиция + 1);
			Иначе
				Имя = ИмяОтчество;
			КонецЕсли
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьИзБазы(Организация)
	
	// Формируем список всех реквизитов и только пустых реквизтов
	Реквизиты    = Метаданные.Документы.ЗаявленияПоЭлДокументооборотуСПФР.Реквизиты;
	ВсеРеквизиты = Новый Структура;
	ПустыеРеквизиты = Новый Массив;
	Для каждого Реквизит Из Реквизиты Цикл
		ВсеРеквизиты.Вставить(Реквизит.Имя);
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект[Реквизит.Имя]) Тогда
			ПустыеРеквизиты.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	// Для заполнения сертификата
	ВсеРеквизиты.Вставить("Вид", ЭтотОбъект.Вид);
	ВсеРеквизиты.Вставить("Организация", ЭтотОбъект.Организация);
	
	Если ПустыеРеквизиты.Количество() > 0 Тогда
		
		ВсеРеквизиты.Организация = Организация;
		// Заполняем все реквизиты
		Документы.ЗаявленияПоЭлДокументооборотуСПФР.ЗаполнитьИзБазы(ВсеРеквизиты);
		ПустыеРеквизиты = СтрСоединить(ПустыеРеквизиты, ",");
		// Копируем в объект только те реквизиты, которые в объетке пустые
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВсеРеквизиты, ПустыеРеквизиты);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИсключитьЛишниеРеквизитыДляИП(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("КПП"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("НаименованиеКраткое"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("НаименованиеПолное"));
	
КонецПроцедуры

Процедура ИсключитьЛишниеРеквизитыДляСертификата(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	ПроверяемыеРеквизиты.Добавить("Вид");
	ПроверяемыеРеквизиты.Добавить("Организация");
	
КонецПроцедуры

Функция ПроверитьСертификат(Отказ)
	
	// Здесь хочется сделать проверку только для заявлений на подключение,
	// но для того, чтобы отправить заявление на отключение, тоже нужна учетка.
	// Поэтому проверяем для любого вида заявления.
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "ПредставлениеСертификата";
	
	ДвДанныеСертификата = Сертификат.Получить();
	Если ДвДанныеСертификата = Неопределено Тогда
		РезультатПроверки.ТекстОшибки = НСтр("ru = 'Укажите отправляемый сертификат'");
	Иначе
		
		СертификатИзЗаявления   = Новый СертификатКриптографии(ДвДанныеСертификата);
		СертификатДатаОкончания = СертификатИзЗаявления.ДатаОкончания;
		СертификатПросрочен     = СертификатДатаОкончания < ТекущаяДатаСеанса();
		
		Если СертификатПросрочен Тогда
			
			ТекстОшибки = НСтр("ru = 'Заявление не может быть отправлено, поскольку срок действия сертификата истек %1'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Строка(МестноеВремя(СертификатДатаОкончания)));
			
			РезультатПроверки.ТекстОшибки = ТекстОшибки;
			
		КонецЕсли;
			
	КонецЕсли;

	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Процедура ЗаполнитьНаименование() Экспорт
	
	Если ЗначениеЗаполнено(Вид) = Перечисления.ВидыЗаявленийНаЭДОВПФР.НаПодключение Тогда 
		Наименование = Строка(Вид);
	Иначе
		Наименование = СтрШаблон("Заявление по эл. документообороту с ПФР");
	КонецЕсли;

КонецПроцедуры

Функция ПроверитьИНН(ИмяРеквизита, Отказ, ЭтоЮридическоеЛицо)
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект." + ИмяРеквизита;
	
	ЭтотОбъект[ИмяРеквизита] = СокрЛП(ЭтотОбъект[ИмяРеквизита]);
	ЗначениеИНН = ЭтотОбъект[ИмяРеквизита];
	
	Представление = Строка(ЭтотОбъект.Метаданные().Реквизиты[ИмяРеквизита]);
	
	// ИНН
	Если ЗначениеЗаполнено(ЗначениеИНН) Тогда
		
		Если ЭтоЮридическоеЛицо И СтрДлина(ЗначениеИНН) <> 10 Тогда
			
			РезультатПроверки.ТекстОшибки = Представление + НСтр("ru = ' должен состоять из 10 цифр'");
			РезультатПроверки.Пустой	  = СтрДлина(ЗначениеИНН) < 10;
			
		ИначеЕсли НЕ ЭтоЮридическоеЛицо И СтрДлина(ЗначениеИНН) <> 12 Тогда
				
			РезультатПроверки.ТекстОшибки = Представление + НСтр("ru = ' должен состоять из 12 цифр'");
			РезультатПроверки.Пустой	  = СтрДлина(ЗначениеИНН) < 12;

		Иначе
			РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ЗначениеИНН, ЭтоЮридическоеЛицо, РезультатПроверки.ТекстОшибки);
			
			Если ЗначениеЗаполнено(РезультатПроверки.ТекстОшибки) Тогда
				РезультатПроверки.ТекстОшибки  = Представление + ": " + РезультатПроверки.ТекстОшибки;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Функция ПроверитьКПП(ИмяРеквизита, Отказ, ЭтоЮридическоеЛицо)
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект." + ИмяРеквизита;
	
	ЭтотОбъект[ИмяРеквизита] = СокрЛП(ЭтотОбъект[ИмяРеквизита]);
	ЗначениеКПП = ЭтотОбъект[ИмяРеквизита];
	
	Представление = Строка(ЭтотОбъект.Метаданные().Реквизиты[ИмяРеквизита]);
	
	ТекстОшибки = "";
	Если ЭтоЮридическоеЛицо Тогда

		Если ДокументооборотСКОКлиентСервер.НайденыЗапрещенныеСимволы(
			ЗначениеКПП, 
			Представление, 
			ИмяРеквизита,
			Истина,
			ТекстОшибки)Тогда
			
			РезультатПроверки.ТекстОшибки = ТекстОшибки;

		ИначеЕсли НЕ ДокументооборотСКОКлиентСервер.ПроверитьКПП(ЗначениеКПП) И ЗначениеЗаполнено(ЗначениеКПП) Тогда
			
			РезультатПроверки.ТекстОшибки = Представление + НСтр("ru = ' должен состоять из 9 цифр'");
			РезультатПроверки.Пустой	  = Истина;
			
		КонецЕсли;
		
	КонецЕсли;

	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Функция ПроверитьРегНомерПФР(ИмяРеквизита, Отказ)
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект." + ИмяРеквизита;
	
	ЭтотОбъект[ИмяРеквизита] = СокрЛП(ЭтотОбъект[ИмяРеквизита]);
	ЗначениеРегНомераПФР = ЭтотОбъект[ИмяРеквизита];
	
	Представление = Строка(ЭтотОбъект.Метаданные().Реквизиты[ИмяРеквизита]);
		
	Если НЕ ДокументооборотСКОКлиентСервер.ПроверитьРегистрационныйНомерПФР(ЗначениеРегНомераПФР, Истина) Тогда
		РезультатПроверки.ТекстОшибки = Представление + НСтр("ru = ' должен состоять из 12 цифр (ХХХ-ХХХ-ХХХХХХ)'");
	КонецЕсли;

	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Функция ПроверитьАдрес(Отказ, ЗначениеАдреса, Путь, НазваниеАдреса)
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = Путь;
	
	Если НЕ ЗначениеЗаполнено(ЗначениеАдреса) Тогда 
		
		РезультатПроверки.ТекстОшибки = СтрШаблон(НСтр("ru = 'Укажите %1.'"), НазваниеАдреса);
		РезультатПроверки.Пустой	  = Истина;
		
	КонецЕсли;

	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Процедура ПроверитьСНИЛС(Отказ)
	
	ЭтоЮридическоеЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Организация);
	
	Если ЭтоЮридическоеЛицо Тогда
		Возврат;
	КонецЕсли;
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект.СНИЛС";
	
	СНИЛСБезРазделителей = СНИЛСБезРазделителей(СНИЛС);
	
	Если НЕ ПустаяСтрока(СНИЛСБезРазделителей) Тогда
		Если НЕ ДокументооборотСКОКлиентСервер.ПроверитьСНИЛС(СНИЛС) Тогда
			РезультатПроверки.ТекстОшибки = НСтр("ru = 'Некорректно указан СНИЛС. Не соответствует маске ХХХ-ХХХ-ХХХ ХХ, где X - любая цифра'");
		ИначеЕсли НЕ ДокументооборотСКОКлиентСервер.ПроверитьСНИЛС(СНИЛС, Ложь, Истина) Тогда
			РезультатПроверки.ТекстОшибки = НСтр("ru = 'Некорректно указан СНИЛС. Не сошлось контрольное число (СНИЛС не существует)'");
		КонецЕсли;
	КонецЕсли;

	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецПроцедуры

Функция ПроверитьТелефон(Отказ)
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект.Телефон";
	
	// Телефон
	ТелефонБезРазделителей = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ТелефонМобильныйБезРазделителей(Телефон);
	
	Если ЗначениеЗаполнено(ТелефонБезРазделителей) Тогда
		Если НЕ ДокументооборотСКОКлиентСервер.ПроверитьЦифровойКодЗаданнойДлины(ТелефонБезРазделителей, 11, Истина) Тогда 
			РезультатПроверки.ТекстОшибки = НСтр("ru = 'Телефон должен иметь формат +7 XXX XXX-XX-XX'");
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Функция ПроверитьЭлПочту(Отказ)
	
	ТекстОшибки = "";
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект.ЭлектроннаяПочта";
	
	// электронная почта
	ЭлектроннаяПочта = СокрЛП(ЭлектроннаяПочта);
	
	Если ЗначениеЗаполнено(ЭлектроннаяПочта) Тогда
		Если ДокументооборотСКОКлиентСервер.НайденыЗапрещенныеСимволы(
				ЭлектроннаяПочта, 
				НСтр("ru = 'Электронная почта '"),
				"ЭлектроннаяПочтаДляПаролей",
				Истина,
				ТекстОшибки) Тогда
				
			РезультатПроверки.ТекстОшибки = ТекстОшибки;
			
		ИначеЕсли НЕ ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектроннаяПочта) Тогда
				
			Если НЕ СтрНайти(ЭлектроннаяПочта, "@") Тогда
				РезультатПроверки.ТекстОшибки = НСтр("ru = 'Некорректно указана электронная почта. Отсутствует символ @'");
			Иначе 
				РезультатПроверки.ТекстОшибки = НСтр("ru = 'Электронная почта содержит некорректные сочетания символов'");
			КонецЕсли;
				
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Функция СНИЛСБезРазделителей(СНИЛС)

	СНИЛСТолькоЦифры = СтрЗаменить(СНИЛС, "-","");
	СНИЛСТолькоЦифры = СтрЗаменить(СНИЛСТолькоЦифры, " ","");
	
	Возврат СНИЛСТолькоЦифры;

КонецФункции

Функция ПроверитьУчетку(Отказ)
	
	// Здесь хочется сделать проверку только для заявлений на подключение,
	// но для того, чтобы отправить заявление на отключение, тоже нужна учетка.
	// Поэтому проверяем для любого вида заявления.
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект.Организация";
	
	УчетнаяЗапись = КонтекстЭДОСервер.УчетнаяЗаписьОрганизации(Организация);
	
	Если НЕ ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		РезультатПроверки.ТекстОшибки = НСтр("ru = 'Отправка заявления возможна только после подключения к 1С-Отчетности'");
	КонецЕсли;

	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Процедура УстановитьОтказ(Отказ, РезультатПроверки)
	
	Если ЗначениеЗаполнено(РезультатПроверки.ТекстОшибки) Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(РезультатПроверки.ТекстОшибки,ЭтотОбъект,,РезультатПроверки.Поле);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли