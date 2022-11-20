
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает структуру значений по умолчанию для документа для движений.
//
// Возвращаемое значение:
//	Структура - значения по умолчанию
//
Функция ЗначенияПоУмолчанию(СсылкаНаОформляемыйДокумент) Экспорт
	
	СтруктураЗначенияПоУмолчанию = Новый Структура;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(СсылкаНаОформляемыйДокумент);
	
	СтруктураЗначенияПоУмолчанию.Вставить("Документ", СсылкаНаОформляемыйДокумент);
	СтруктураЗначенияПоУмолчанию.Вставить("Статус",   МенеджерОбъекта.СтатусПоУмолчанию());
	
	СтекДействий = Новый Массив;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ОбъектРасчета", СсылкаНаОформляемыйДокумент);
	
	ДальнейшееДействиеПоУмолчанию = МенеджерОбъекта.ДальнейшееДействиеПоУмолчанию(СтруктураПараметров);
	
	Если ТипЗнч(ДальнейшееДействиеПоУмолчанию) = Тип("Массив") Тогда
		Для Каждого Действие Из ДальнейшееДействиеПоУмолчанию Цикл
			СтекДействий.Добавить(Действие);
		КонецЦикла;
	Иначе
		СтекДействий.Добавить(ДальнейшееДействиеПоУмолчанию);
	КонецЕсли;
	
	СтекДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется);
	СтекДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется);
	
	МассивКлючейДальнейшихДействий = Новый Массив;
	МассивКлючейДальнейшихДействий.Добавить("ДальнейшееДействие1");
	МассивКлючейДальнейшихДействий.Добавить("ДальнейшееДействие2");
	МассивКлючейДальнейшихДействий.Добавить("ДальнейшееДействие3");
	
	Для Каждого ДальнейшееДействиеКлюч Из МассивКлючейДальнейшихДействий Цикл
		СтруктураЗначенияПоУмолчанию.Вставить(ДальнейшееДействиеКлюч, СтекДействий.Получить(0));
		СтекДействий.Удалить(0);
	КонецЦикла;
	
	Возврат СтруктураЗначенияПоУмолчанию;
	
КонецФункции

// Осуществляет запись в регистр по переданным данным.
//
// Параметры:
//  ДанныеЗаписи - данные для записи в регистр
//
Процедура ВыполнитьЗаписьВРегистр(ДанныеЗаписи) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.СтатусыДокументовИСМП.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДанныеЗаписи);
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Обработать набор записей регистра.
//
// Параметры:
//  НаборЗаписей - РегистрСведенийНаборЗаписей.СтатусыДокументовИСМП - Набор записей.
//  ПараметрыОбновления - (См. ВозвращаемоеЗначениеДальнейшиеДействияСтатус).
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка - Новый статус.
//   * СтарыйСтатус - ПеречислениеСсылка - Старый статус.
//   * ЗаписатьНабор - Булево - Признак необходимости записи набора.
//
Функция ОбработатьНаборЗаписей(НаборЗаписей, ПараметрыОбновления, ЭтоНовый = Истина) Экспорт
	
	НовыйСтатус   = Неопределено;
	СтарыйСтатус  = Неопределено;
	ЗаписатьНабор = Неопределено;
	
	Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
		Если ЗаписьНабора.Статус <> ПараметрыОбновления.НовыйСтатус Или ЭтоНовый Тогда
			СтарыйСтатус = ЗаписьНабора.Статус;
			ЗаписьНабора.Статус = ПараметрыОбновления.НовыйСтатус;
			НовыйСтатус = ПараметрыОбновления.НовыйСтатус;
			ЗаписатьНабор = Истина;
		КонецЕсли;
		Если ЗаписьНабора.ДальнейшееДействие1 <> ПараметрыОбновления.ДальнейшееДействие1 Тогда
			ЗаписьНабора.ДальнейшееДействие1 = ПараметрыОбновления.ДальнейшееДействие1;
			ЗаписатьНабор = Истина;
		КонецЕсли;
		Если ЗаписьНабора.ДальнейшееДействие2 <> ПараметрыОбновления.ДальнейшееДействие2 Тогда
			ЗаписьНабора.ДальнейшееДействие2 = ПараметрыОбновления.ДальнейшееДействие2;
			ЗаписатьНабор = Истина;
		КонецЕсли;
		Если ЗаписьНабора.ДальнейшееДействие3 <> ПараметрыОбновления.ДальнейшееДействие3 Тогда
			ЗаписьНабора.ДальнейшееДействие3 = ПараметрыОбновления.ДальнейшееДействие3;
			ЗаписатьНабор = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("НовыйСтатус",   НовыйСтатус);
	ВозвращаемоеЗначение.Вставить("СтарыйСтатус",  СтарыйСтатус);
	ВозвращаемоеЗначение.Вставить("ЗаписатьНабор", ЗаписатьНабор);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Дополнить параметры обновления статуса.
//
// Параметры:
//  ПараметрыОбновленияСтатуса - Структура - см. функцию ИнтеграцияИСМПСлужебныйКлиентСервер.ПараметрыОбновленияСтатуса().
// 
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияИСМП.ПараметрыОбновленияСтатуса().
//
Функция ДополнитьПараметрыОбновленияСтатуса(ПараметрыОбновленияСтатуса = Неопределено) Экспорт
	
	Если ПараметрыОбновленияСтатуса = Неопределено Тогда
		
		ПараметрыОбновленияСтатуса = ИнтеграцияИСМПСлужебныйКлиентСервер.ПараметрыОбновленияСтатуса();
		
	КонецЕсли;
	
	Возврат ПараметрыОбновленияСтатуса;
	
КонецФункции

// Изменяет и возвращает статус документа ИСМП.
//
// Параметры:
//  Документ - ДокументСсылка - Документ ИСМП.
//  ПараметрыОбновления - Структура со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//  ОбновлятьДвижения - Булево - Признак принудительного обновления движений.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыИнформированияИСМП - новый статус документа ИСМП.
//
Функция ОбновитьСтатус(Документ, ПараметрыОбновления, ДополнительныеПараметры = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПараметрыОбновления = Неопределено Тогда
		ДанныеЗаписи = ЗначенияПоУмолчанию(Документ);
		ВыполнитьЗаписьВРегистр(ДанныеЗаписи);
		Возврат ДанныеЗаписи.Статус;
	КонецЕсли;
	
	Если ПараметрыОбновления.НовыйСтатус = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка изменения статуса'");
	КонецЕсли;
	
	ЭтоНовый = Ложь;
	НаборЗаписей = НаборЗаписей(Документ, ЭтоНовый);
	ЗаписатьНабор = НаборЗаписей.Модифицированность();
	
	Результат = ОбработатьНаборЗаписей(НаборЗаписей, ПараметрыОбновления, ЭтоНовый);
	Если Результат.ЗаписатьНабор <> Неопределено Тогда
		ЗаписатьНабор = Результат.ЗаписатьНабор;
	КонецЕсли;
	НовыйСтатус  = Результат.НовыйСтатус;
	СтарыйСтатус = Результат.СтарыйСтатус;
	
	Если ЗаписатьНабор Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		НаборЗаписей.Записать();
		
		Если СтарыйСтатус <> НовыйСтатус Тогда
			
			ПолноеИмя = Документ.Метаданные().ПолноеИмя();
			МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
			
			ПараметрыОбновленияСтатуса = ДополнитьПараметрыОбновленияСтатуса(ДополнительныеПараметры);
			
			МенеджерОбъекта.ПриИзмененииСтатусаДокумента(
				Документ,
				СтарыйСтатус, 
				НовыйСтатус,
				ПараметрыОбновленияСтатуса);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НовыйСтатус;
	
КонецФункции

Процедура ЗаписатьСтатус(Документ, ПараметрыОбновления, ДополнительныеПараметры = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	ЗначенияПоУмолчанию = ЗначенияПоУмолчанию(Документ);
	ЗаписьНабора = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗначенияПоУмолчанию);
	ОбработатьНаборЗаписей(НаборЗаписей, ПараметрыОбновления);
	НаборЗаписей.Записать(Истина);
	
	ПолноеИмя = Документ.Метаданные().ПолноеИмя();
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
	
	ПараметрыОбновленияСтатуса = ДополнитьПараметрыОбновленияСтатуса(ДополнительныеПараметры);
	
	МенеджерОбъекта.ПриИзмененииСтатусаДокумента(
		Документ,
		Неопределено, ПараметрыОбновления.НовыйСтатус,
		ПараметрыОбновленияСтатуса);
	
КонецПроцедуры

Функция ТекущееСостояние(Документ) Экспорт
	
	ВозвращаемоеЗначение = ЗначенияПоУмолчанию(Документ);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СтатусыДокументовИСМП.Документ,
	|	СтатусыДокументовИСМП.Статус,
	|	СтатусыДокументовИСМП.ДальнейшееДействие1,
	|	СтатусыДокументовИСМП.ДальнейшееДействие2,
	|	СтатусыДокументовИСМП.ДальнейшееДействие3
	|ИЗ
	|	РегистрСведений.СтатусыДокументовИСМП КАК СтатусыДокументовИСМП
	|ГДЕ
	|	СтатусыДокументовИСМП.Документ = &Документ");
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(ВозвращаемоеЗначение, Выборка);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция РассчитатьСтатусы(ДокументСсылка, СтатусОбработки, Статусы) Экспорт
	
	Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийИСМП.ЗаявкаОтклонена
		Или СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийИСМП.Ошибка Тогда
		
		ДальнейшиеДействия = Новый Массив;
		Для Каждого Действие Из Статусы.ОшибкаДействия Цикл
			ДальнейшиеДействия.Добавить(Действие);
		КонецЦикла;
		
		Возврат ВозвращаемоеЗначениеДальнейшиеДействияСтатус(Статусы.Ошибка, ДальнейшиеДействия);
		
	ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийИСМП.ЗаявкаОбрабатывается
		Или СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийИСМП.ЗаявкаОжидаетПодтверждения
		Или СтатусОбработки = Перечисления.СтатусыОбработкиЗаказовНаЭмиссиюКодовМаркировкиИСМП.СУЗПринятКОбработке
		Или СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийИСМП.ЗаявкаОжидаетРегистрациюУчастникаГИСМТ Тогда
		
		Если Статусы.Обрабатывается = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ДальнейшиеДействия = Новый Массив;
		Для Каждого Действие Из Статусы.ОбрабатываетсяДействия Цикл
			ДальнейшиеДействия.Добавить(Действие);
		КонецЦикла;
		
		Возврат ВозвращаемоеЗначениеДальнейшиеДействияСтатус(Статусы.Обрабатывается, ДальнейшиеДействия);
		
	ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийИСМП.ЗаявкаВыполнена
		Или СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийИСМП.ЗаявкаПринята
		Или СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийИСМП.ЗаявкаАннулирована Тогда
		
		ДальнейшиеДействия = Новый Массив;
		Для Каждого Действие Из Статусы.ПринятДействия Цикл
			ДальнейшиеДействия.Добавить(Действие);
		КонецЦикла;
		
		Возврат ВозвращаемоеЗначениеДальнейшиеДействияСтатус(Статусы.Принят, ДальнейшиеДействия);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неизвестный статус обработки: %1'"), СтатусОбработки);
		
	КонецЕсли;
	
КонецФункции

Функция РассчитатьСтатусыКПередаче(ДокументСсылка, НовыйСтатус) Экспорт
	
	ИспользоватьАвтоматическийОбмен = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхИСМП");
	
	ДальнейшиеДействия = Новый Массив;
	Если ИспользоватьАвтоматическийОбмен Тогда
		ДальнейшиеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	Иначе
		ДальнейшиеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ВыполнитеОбмен);
	КонецЕсли;
	
	ДальнейшиеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ОтменитеПередачуДанных);
	
	Возврат ВозвращаемоеЗначениеДальнейшиеДействияСтатус(НовыйСтатус, ДальнейшиеДействия);
	
КонецФункции

Функция ДальнейшиеДействия(Статусы) Экспорт
	
	ВозвращаемоеЗначение = Новый Массив;
	
	Если Статусы.ДальнейшееДействие1 <> Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется Тогда
		ВозвращаемоеЗначение.Добавить(Статусы.ДальнейшееДействие1);
	КонецЕсли;
	Если Статусы.ДальнейшееДействие2 <> Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется Тогда
		ВозвращаемоеЗначение.Добавить(Статусы.ДальнейшееДействие2);
	КонецЕсли;
	Если Статусы.ДальнейшееДействие3 <> Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется Тогда
		ВозвращаемоеЗначение.Добавить(Статусы.ДальнейшееДействие3);
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Выполняет запись в регистр дальнейших действий, обозначающих архивирование документов.
// 
// Параметры:
// 	ДокументыКАрхивированию - Массив - Документы для архивирования.
// Возвращаемое значение:
// 	Массив из ИнтеграцияЕГАИСКлиентСервер.СтруктураИзменения - Массив результатов архивирования.
//
Функция Архивировать(ДокументыКАрхивированию) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Изменения = Новый Массив;
	
	Для Каждого ДокументСсылка Из ДокументыКАрхивированию Цикл
		
		ЗначенияЗаписи = ТекущееСостояние(ДокументСсылка);
		ЗначенияЗаписи.ДальнейшееДействие1 = Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется;
		ЗначенияЗаписи.ДальнейшееДействие2 = Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется;
		ЗначенияЗаписи.ДальнейшееДействие3 = Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется;
		
		Если Не ПравоДоступа("Изменение", ДокументСсылка.Метаданные()) Тогда
			ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа для очистки дальнейших действий по документу'");
		КонецЕсли;
	
		НачатьТранзакцию();
		
		УстановитьПривилегированныйРежим(Истина);
		Попытка
			
			ВыполнитьЗаписьВРегистр(ЗначенияЗаписи);
			
			ДокументОснование = Неопределено;
			Если ДокументСсылка.Метаданные().Реквизиты.Найти("ДокументОснование") <> Неопределено Тогда
				ДокументОснование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "ДокументОснование");
			КонецЕсли;
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ОчередьСообщенийИСМП.Сообщение КАК Сообщение
			|ИЗ
			|	РегистрСведений.ОчередьСообщенийИСМП КАК ОчередьСообщенийИСМП
			|ГДЕ
			|	ОчередьСообщенийИСМП.Документ = &Документ");
			Запрос.Параметры.Вставить("Документ", ДокументСсылка);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				НаборЗаписей = РегистрыСведений.ОчередьСообщенийИСМП.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Сообщение.Установить(Выборка.Сообщение, Истина);
				НаборЗаписей.Записать();
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
			ТекстОшибки = "";
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'При архивировании документа %1 возникла ошибка:
				           |Текст ошибки: %2'"),
				ДокументСсылка,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ИнтеграцияЕГАИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки);
			
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			
		КонецПопытки;
		УстановитьПривилегированныйРежим(Ложь);
		
		СтрокаРезультата = ИнтеграцияИСМПСлужебный.СтруктураИзменения();
		СтрокаРезультата.Объект            = ДокументСсылка;
		СтрокаРезультата.ДокументОснование = ДокументОснование;
		СтрокаРезультата.ТекстОшибки       = ТекстОшибки;
		
		Изменения.Добавить(СтрокаРезультата);
		
	КонецЦикла;
	
	Возврат Изменения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НаборЗаписей(Документ, ЭтоНовый)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СтатусыДокументовИСМП.Документ КАК Документ
	|ИЗ
	|	РегистрСведений.СтатусыДокументовИСМП КАК СтатусыДокументовИСМП
	|ГДЕ
	|	СтатусыДокументовИСМП.Документ = &Документ");
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЭтоНовый = Запрос.Выполнить().Пустой();
	
	НаборЗаписей = РегистрыСведений.СтатусыДокументовИСМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ, Истина);
	
	Если ЭтоНовый Тогда
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗначенияПоУмолчанию(Документ));
		
	Иначе
		
		НаборЗаписей.Прочитать();
		
	КонецЕсли;
	
	Возврат НаборЗаписей;
	
КонецФункции

Функция СтруктураСтатусы() Экспорт
	
	Статусы = Новый Структура;
	Статусы.Вставить("Принят");
	Статусы.Вставить("Обрабатывается");
	Статусы.Вставить("Ошибка");
	
	Статусы.Вставить("ОшибкаДействия",         Новый Массив);
	Статусы.Вставить("ПринятДействия",         Новый Массив);
	Статусы.Вставить("ОбрабатываетсяДействия", Новый Массив);
	
	Возврат Статусы;
	
КонецФункции

Функция ВозвращаемоеЗначениеДальнейшиеДействияСтатус(Статус, ДальнейшиеДействия) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("НовыйСтатус",         Статус);
	ВозвращаемоеЗначение.Вставить("ДальнейшееДействие1", Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется);
	ВозвращаемоеЗначение.Вставить("ДальнейшееДействие2", Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется);
	ВозвращаемоеЗначение.Вставить("ДальнейшееДействие3", Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.НеТребуется);
	
	Индекс = 1;
	Для Каждого ДальнейшееДействие Из ДальнейшиеДействия Цикл
		ВозвращаемоеЗначение["ДальнейшееДействие" + Индекс] = ДальнейшееДействие;
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#КонецЕсли