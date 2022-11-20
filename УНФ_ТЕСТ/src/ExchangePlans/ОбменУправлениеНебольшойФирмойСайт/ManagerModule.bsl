#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Возвращает структуру отборов на узле плана обмена базы корреспондента с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена базы корреспондента
// 
Функция НастройкаОтборовНаУзлеБазыКорреспондента() Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

// Возвращает структуру значений по умолчению для узла базы корреспондента;
// Структура настроек повторяет состав реквизитов шапки плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента
//
Функция ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента() Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных отборов на узле базы корреспондента должен сформировать строку
// описания ограничений удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции НастройкаОтборовНаУзлеБазыКорреспондента().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанныхБазыКорреспондента(НастройкаОтборовНаУзле) Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает строку описания значений по умолчанию для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных значений по умолчанию на узле базы корреспондента должен сформировать
// строку описания удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания для пользователя значений по умолчанию
//
Функция ОписаниеЗначенийПоУмолчаниюБазыКорреспондента(ЗначенияПоУмолчаниюНаУзле) Экспорт
	
	Возврат "";
	
КонецФункции

// Функция возвращает имя обработки выгрузки данных
//
Функция ИмяОбработкиВыгрузки() Экспорт
	
	Возврат "";
	
КонецФункции // ИмяОбработкиВыгрузки()

// Функция возвращает имя обработки загрузки данных
//
Функция ИмяОбработкиЗагрузки() Экспорт
	
	Возврат "";
	
КонецФункции // ИмяОбработкиЗагрузки()

// Функция должна возвращать:
// Истина, в том случае, если корреспондент поддерживает сценарий обмена, 
// в котором текущая ИБ работает в локальном режиме, 
// а корреспондент в модели сервиса. 
// 
// Ложь – если такой сценарий обмена не поддерживается.
//
Функция КорреспондентВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции // КорреспондентВМоделиСервиса()

// Возвращает имя семейства конфигураций. 
// Используется для поддержки обменов с измененными конфигурациями в сервисе.
//
Функция ИмяКонфигурацииИсточника() Экспорт
	
	Возврат "УправлениеНашейФирмой";
	
КонецФункции // ИмяКонфигурацииИсточника()

#КонецОбласти

#КонецЕсли
