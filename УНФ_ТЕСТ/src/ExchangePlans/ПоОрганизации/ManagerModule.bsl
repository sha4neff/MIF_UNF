#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.НазначениеПланаОбмена = "РИБСФильтром";
	Настройки.Алгоритмы.ОписаниеОграниченийПередачиДанных = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()
		И Константы.УчетПоКомпании.Получить() Тогда
		
		ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = ЗаголовокИспользуетсяУчетПоКомпании();
	Иначе
		ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Удаленное рабочее место организации (РИБ)'");
	КонецЕсли;
	
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки обмена удаленное рабочего места'");
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;
	ОписаниеВарианта.Отборы = НастройкаОтборовНаУзле();
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = НСтр("ru = 'Распределенная информационная база представляет собой иерархическую структуру, состоящую из отдельных информационных 
	|баз системы «1С:Предприятие» — узлов распределенной информационной базы, между которыми организована синхронизация 
	|конфигурации и данных. Главной особенностью распределенных информационных баз является передача изменений 
	|конфигурации в подчиненные узлы.
	|Необходимо указать ограничения миграции данных по организациям.'");
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "ПланОбмена.ПоОрганизации.Форма.ПодробнаяИнформация";
	
КонецПроцедуры

// Возвращает строку описания ограничений миграции данных для пользователя;
// Прикладной разработчик на основе установленных отборов на узле должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена,
//                                       полученная при помощи функции НастройкаОтборовНаУзле().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Если НастройкаОтборовНаУзле.Организации.Организация.Количество() > 0 Тогда 
		СтрокаПредставленияОтбора = СтрСоединить(НастройкаОтборовНаУзле.Организации.Организация, "; ");
		НСтрока = НСтр("ru = 'Только по организациям: %1'");
		ОграничениеОтборПоОрганизациям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, СтрокаПредставленияОтбора);
		Возврат ОграничениеОтборПоОрганизациям;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция ЗаголовокИспользуетсяУчетПоКомпании() Экспорт
	
	Возврат НСтр("ru = 'Удаленное рабочее место организации не совместимо с опцией ""Учет по компании""'");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена
// 
Функция НастройкаОтборовНаУзле()
	
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("Организации",СтруктураТабличнойЧастиОрганизации);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает режим запуска, в случае интерактивного инициирования синхронизации
// Возвращаемые значения АвтоматическаяСинхронизация Или ИнтерактивнаяСинхронизация
// На основании этих значений запускается либо помощник интерактивного обмена, либо автообмен
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт
	// Пример типового возврата
	Возврат "";
КонецФункции

// Возвращает сценарий работы помощника интерактивного сопостовления
// НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	// Пример типового возврата
	Возврат "";
КонецФункции

// Возвращает значения ограничений объектов узла плана обмена для интерактивной регистрации к обмену
// Структура: ВсеДокументы, ВсеСправочники, ДетальныйОтбор
// Детальный отбор либо неопределено, либо массив объектов метаданных входящих в состав узла (Указывается полное имя метаданных)
Функция ДобавитьГруппыОграничений(УзелИнформационнойБазы) Экспорт
	// Пример типового возврата
	Возврат Новый Структура("ВсеДокументы, ВсеСправочники, ДетальныйОтбор", Ложь, Ложь, Неопределено);
КонецФункции

#КонецОбласти

#КонецЕсли