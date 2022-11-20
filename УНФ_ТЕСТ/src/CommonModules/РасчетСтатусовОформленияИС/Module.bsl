// Общая часть расчета статусов оформления документов ГосИС (ЕГАИС, ВетИС, ИС МП):
//  * Обработчики подписок на события записи документов, участвующих в статусах оформления и команд пересчета статуса
//  * Общие параметры расчета статусов оформления ГосИС
// Детали реализации см. в соответствующем модуле

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПересчетаСтатуса

// Обработчик подписки на событие "Перед записью" документов ГосИС, поддерживающих статусы оформления
//
// Параметры:
//   ИмяОпцииИспользованияПодсистемы - Строка - имя функциональной опции влияющей на использование функциональности
//   Источник - ДокументОбъект - записываемый объект, поддерживающий статусы оформления,
//                               должен содержать реквизит ДокументОснование.
//   Отказ - Булево - признак (установленного ранее) отказа от записи
//
Процедура ПередЗаписьюДокумента(ИмяОпцииИспользованияПодсистемы, Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию(ИмяОпцииИспользованияПодсистемы) Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("НеВыполнятьРасчетСтатусаГосИС") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Источник.Ссылка) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Источник.ДополнительныеСвойства.Вставить(
			"ПредыдущийДокументОснование",
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "ДокументОснование"));
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик подписки на событие "При записи" документов ГосИС, поддерживающих статусы оформления, и их документов-оснований
//
// Параметры:
//   ИмяОпцииИспользованияПодсистемы - Строка - имя функциональной опции влияющей на использование функциональности
//   Источник - ДокументОбъект - записываемый объект.
//   Отказ    - Булево - параметр, определяющий будет ли записываться объект.
//   Модуль   - ОбщийМодуль - модуль, определяющий специфику подсистемы.
//
Процедура ПриЗаписиДокумента(ИмяОпцииИспользованияПодсистемы, Источник, Отказ, Модуль) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию(ИмяОпцииИспользованияПодсистемы) Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("НеВыполнятьРасчетСтатусаГосИС") Тогда
		Возврат;
	КонецЕсли;
	
	Если Модуль.ЭтоДокументПоддерживающийСтатусОформления(Источник) Тогда
		
		// Записывается документ ГосИС.
		Если Источник.ДополнительныеСвойства.Свойство("ПредыдущийДокументОснование")
		 И ЗначениеЗаполнено(Источник.ДополнительныеСвойства.ПредыдущийДокументОснование)
		 И Источник.ДополнительныеСвойства.ПредыдущийДокументОснование <> Источник.ДокументОснование Тогда
			
			// Обновим статус оформления для документа-основания, который был раньше указан в записываемом документе ГосИС.
			Модуль.РассчитатьСтатусОформленияДокумента(Источник.ДополнительныеСвойства.ПредыдущийДокументОснование);
			
	 	КонецЕсли;
		
	КонецЕсли;
	
	Модуль.РассчитатьСтатусОформленияДокумента(Источник);
	
КонецПроцедуры

// Обработчик группового программного пересчета статусов оформления не привязанный к подпискам на события
// Рассчитывает статусы оформления документов и записывает их в регистр сведений СтатусыОформления*.
// ВАЖНО: все элементы массива Источники должны иметь одинаковый тип.
//
// Параметры:
//  ИмяОпцииИспользованияПодсистемы - Строка - имя функциональной опции влияющей на использование функциональности
//  Источники - ДокументСсылка, СправочникСсылка, Массив Из ДокументСсылка, Массив Из СправочникСсылка - объекты для расчета статуса оформления
//  Модуль - ОбщийМодуль - модуль, определяющий специфику подсистемы.
//
// Возвращаемое значение:
//   Булево - общая часть расчета успешно выполнена
//
Функция РассчитатьДляДокументов(ИмяОпцииИспользованияПодсистемы, Источники, Модуль) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию(ИмяОпцииИспользованияПодсистемы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Источники) <> Тип("Массив") Тогда
		ДокументыДляРасчетаСтатусов = Новый Массив;
		ДокументыДляРасчетаСтатусов.Добавить(Источники);
	Иначе
		ДокументыДляРасчетаСтатусов = Источники;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РассчитатьОбщая(ДокументыДляРасчетаСтатусов, Неопределено, Модуль);
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область ОбщееИспользованиеЗначений

// Устанавливает служебный признак в доп. свойствах объекта, который отключает автоматический пересчет статуса оформления.
// Следует использовать при программном формировании нескольких однотипных документов.
//
// Параметры:
//   Источник - ДокументОбъект - записываемый объект
//
Процедура НеВыполнятьРасчетСтатусаПриЗаписиОбъекта(Источник) Экспорт
	
	Источник.ДополнительныеСвойства.Вставить("НеВыполнятьРасчетСтатусаГосИС", Истина);
	
КонецПроцедуры

// Возвращает имя временной таблицы, в которую необходимо поместить данные документа-основания.
// Необходимо использовать при определении запроса для расчета статуса оформления.
//
// Возвращаемое значение:
//   Строка - имя временной таблицы
//
Функция ИмяВременнойТаблицыДляВыборкиДанныхДокумента() Экспорт
	
	Возврат "ТоварыДокументаОснования";
	
КонецФункции

#КонецОбласти

#Область РасчетСтатусаОформления

// Рассчитывает статус оформления документа и записывает его в регистр сведений СтатусыОформления*.
//
// Параметры:
//   ИмяОпцииИспользованияПодсистемы - Строка - имя функциональной опции влияющей на использование функциональности
//   Источник - ДокументОбъект - записываемый объект.
//   Модуль - ОбщийМодуль - модуль, определяющий специфику подсистемы.
//
// Возвращаемое значение:
//   Булево - общая часть расчета успешно выполнена
//
Функция РассчитатьДляДокумента(ИмяОпцииИспользованияПодсистемы, Источник, Модуль) Экспорт

	Если НЕ ПолучитьФункциональнуюОпцию(ИмяОпцииИспользованияПодсистемы) Тогда
		Возврат Ложь;
	КонецЕсли;

	// Определим тип реквизита Источник.
	ИсточникЭтоСсылка = Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Источник))
		ИЛИ Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(Источник));
	
	ИсточникЭтоДокументИС = Модуль.ЭтоДокументПоддерживающийСтатусОформления(Источник);

	ЭтоОбъект = Ложь;

	// Определим документ-основание.
	Если ИсточникЭтоСсылка Тогда

		Если ИсточникЭтоДокументИС Тогда
			УстановитьПривилегированныйРежим(Истина);
			ДокументОснование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник, "ДокументОснование");
			УстановитьПривилегированныйРежим(Ложь);
		Иначе
			ДокументОснование = Источник;
		КонецЕсли;

	Иначе // Источник-объект
		Если ИсточникЭтоДокументИС Тогда
			ДокументОснование = Источник.ДокументОснование;
		Иначе
			ДокументОснование = Источник.Ссылка;
			ЭтоОбъект = Истина; // Значения реквизитов в параметре Источник, а не в данных ИБ
		КонецЕсли;

	КонецЕсли;

	Если ЗначениеЗаполнено(ДокументОснование) Тогда

		МассивДокументов = Новый Массив;
		МассивДокументов.Добавить(ДокументОснование);

		РассчитатьОбщая(МассивДокументов, ?(ЭтоОбъект, Источник, Неопределено), Модуль);

	КонецЕсли;
	
	// Документ ГосИС может являться основанием для оформления другого документа ГосИС
	Если ИсточникЭтоДокументИС Тогда
		
		ДокументОснование = Неопределено;
		Если ИсточникЭтоСсылка И Модуль.ЭтоДокументОснование(Источник) Тогда
			ДокументОснование = Источник;
		ИначеЕсли Не ИсточникЭтоСсылка И Модуль.ЭтоДокументОснование(Источник.Ссылка) Тогда
			ДокументОснование = Источник.Ссылка;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДокументОснование) Тогда
			
			МассивДокументов = Новый Массив;
			МассивДокументов.Добавить(ДокументОснование);
			РассчитатьОбщая(МассивДокументов, ?(Не ИсточникЭтоСсылка, Источник, Неопределено), Модуль);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Готовит данные к расчету статусов оформления.
//
// Параметры:
//   Источники - Массив из ДокументСсылка - документы ГосИС для расчета статусов.
//   ИсточникОбъект - ДокументОбъект, Неопределено - записываемый документ-основание для документа ГосИС (если заполнен).
//   Модуль - ОбщийМодуль - модуль, определяющий специфику подсистемы.
//
Процедура РассчитатьОбщая(Источники, ИсточникОбъект, Модуль) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Источники) Тогда
		Возврат;
	КонецЕсли;
	
	Источник              = Источники[0];
	МетаданныеИсточника   = Источник.Метаданные();
	МетаРеквизитОснование = ИнтеграцияИС.РеквизитДокументОснованиеДокументаИС(МетаданныеИсточника);
	ИсточникЭтоДокументИС = Модуль.ЭтоДокументПоддерживающийСтатусОформления(Источник);
	ИсточникЭтоОснование  = Модуль.ЭтоДокументОснование(Источник);
	
	// Определим документы-основания.
	Если ИсточникЭтоДокументИС Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Источники",               Источники);
		Запрос.УстановитьПараметр("ПустойДокументОснование", ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(
			МетаРеквизитОснование.Тип));
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТИПЗНАЧЕНИЯ(Т.ДокументОснование) КАК ТипОснования,
		|	Т.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	Документ.%1 КАК Т
		|ГДЕ
		|	Т.Ссылка В (&Источники)
		|	И НЕ Т.ДокументОснование В (&ПустойДокументОснование)
		|ИТОГИ ПО
		|	ТипОснования";
		
		Запрос.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Запрос.Текст,
			МетаданныеИсточника.Имя);
		
		УстановитьПривилегированныйРежим(Истина);
		ВыборкаТипов = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		УстановитьПривилегированныйРежим(Ложь);
		
		Пока ВыборкаТипов.Следующий() Цикл
			
			МассивДокументов  = Новый Массив;
			ВыборкаДокументов = ВыборкаТипов.Выбрать();
			
			Пока ВыборкаДокументов.Следующий() Цикл
				МассивДокументов.Добавить(ВыборкаДокументов.ДокументОснование);
			КонецЦикла;
			
			РассчитатьДляОснований(МассивДокументов, Неопределено, Модуль);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ИсточникЭтоОснование Тогда
		РассчитатьДляОснований(Источники, ИсточникОбъект, Модуль);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает имена документов ГосИС, основанием для которых может являться указанный документ.
//
// Параметры:
//   ДокументОснование - ДокументСсылка - документ-основание для документа ГосИС.
//   ТипОснований      - ОписаниеТипов - коллекция типов документов ГосИС для поиска.
//
// Возвращаемое значение:
//   Массив Из Строка - имена документов ГосИС.
//
Функция ИменаДокументовДляДокументаОснования(ДокументОснование, ТипОснований) Экспорт
	
	ИменаДокументов = Новый Массив;
	
	Для Каждого Тип Из ТипОснований.Типы() Цикл
		
		МетаданныеПоТипу = Метаданные.НайтиПоТипу(Тип);
		ТипыОснования    = ИнтеграцияИС.РеквизитДокументОснованиеДокументаИС(МетаданныеПоТипу).Тип;
		
		Если ТипыОснования.СодержитТип(ТипЗнч(ДокументОснование)) Тогда
			ИменаДокументов.Добавить(МетаданныеПоТипу.Имя);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ИменаДокументов;
	
КонецФункции

// Записывает статусы оформления документов ГосИС в регистр сведений СтатусыОформленияДокументов*.
//
// Параметры:
//   ТаблицаРеквизитов - ТаблицаЗначений - собранные общим механизмом реквизиты для записи статуса
//   РегистрМенеджер - РегистрСведенийМенеджер - регистр "Статусы оформления".
//   Модуль - ОбщийМодуль - модуль, определяющий специфику подсистемы.
//   ДополнительныеПараметры - Произвольный - дополнительные параметры подсистемы.
//
Процедура ЗаписатьСтатусОформленияДокументов(ТаблицаРеквизитов, РегистрМенеджер, Модуль, ДополнительныеПараметры = Неопределено) Экспорт
	
	ДокументыИС = ТаблицаРеквизитов.Скопировать(,"Документ");
	ДокументыИС.Свернуть("Документ");
	ДокументыИС = ДокументыИС.ВыгрузитьКолонку("Документ");
	Для Каждого ПустаяСсылка Из ДокументыИС Цикл
	
		ДокументыПоТипу = ТаблицаРеквизитов.Скопировать(Новый Структура("Документ", ПустаяСсылка));
		МассивДокументов = ДокументыПоТипу.ВыгрузитьКолонку("ДокументОснование");
		МетаданныеДокументаИС = ПустаяСсылка.Метаданные();
		МенеджерВТ = Новый МенеджерВременныхТаблиц;
		
		// Проверим наличие записей регистра статусов.
		ЕстьЗаписиРегистра = РегистрМенеджер.ДокументыОснованияСЗаписямиРегистра(
			МассивДокументов,
			ПустаяСсылка);
	
		КоличествоСтрокДокументовОснования = СформироватьТаблицуТоварыДокументовОснования(
			МассивДокументов,
			МетаданныеДокументаИС,
			Модуль,
			МенеджерВТ);
		
		СтатусыОформленияДокументов = Модуль.ОпределитьСтатусыОформленияДокументов(
			МассивДокументов,
			МетаданныеДокументаИС,
			МенеджерВТ);
		
		Для Каждого ДокументОснование Из МассивДокументов Цикл
			
			ЗначенияРеквизитов = ДокументыПоТипу.Найти(ДокументОснование, "ДокументОснование");
			ЕстьЗаписьРегистра = (ЕстьЗаписиРегистра.Неоформленные.Найти(ДокументОснование) <> Неопределено);
			ЗаписьВАрхиве      = (ЕстьЗаписиРегистра.Архивные.Найти(ДокументОснование) <> Неопределено);
			
			ТребуетсяОформление = Модуль.ТребуетсяОформление(ДокументОснование, ЗначенияРеквизитов, КоличествоСтрокДокументовОснования, ДополнительныеПараметры);
			
			Если ЕстьЗаписьРегистра И НЕ ТребуетсяОформление Тогда
				
				РегистрМенеджер.УдалитьЗаписьРегистра(ДокументОснование, ПустаяСсылка);
			
			ИначеЕсли ЕстьЗаписьРегистра ИЛИ ТребуетсяОформление Тогда
				
				СтатусДокумента = СтатусыОформленияДокументов[ДокументОснование];
				ДанныеЗаписиСтатуса = РегистрМенеджер.ЗначенияПоУмолчанию(ДокументОснование, ПустаяСсылка);
				
				ЗаполнитьЗначенияСвойств(ДанныеЗаписиСтатуса, ЗначенияРеквизитов);
				ЗаполнитьЗначенияСвойств(ДанныеЗаписиСтатуса, СтатусДокумента);
				ДанныеЗаписиСтатуса.Архивный = ЗаписьВАрхиве;
				
				РегистрМенеджер.ВыполнитьЗаписьВРегистр(ДанныеЗаписиСтатуса);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует временную таблицу, содержащую оформляемую в ГосИС продукцию оснований.
//
// Параметры:
//   МассивДокументов - Массив Из СправочникСсылка, ДокументСсылка - документы-основания для документа ГосИС.
//   МетаданныеДокументаИС - ОбъектМетаданныхДокумент - метаданные документа ГосИС, поддерживающиего статусы оформления.
//   Модуль - ОбщийМодуль - модуль, определяющий специфику подсистемы.
//   МенеджерВТ - МенеджерВременныхТаблиц - менеджер временных таблиц, в который будет помещена сформированная временная таблица.
//
// Возвращаемое значение:
//   Соответствие - количество оформляемых строк в каждом из переданных оснований (Ключ - Элемент Из МассивДокументов).
//
Функция СформироватьТаблицуТоварыДокументовОснования(МассивДокументов, МетаданныеДокументаИС, Модуль, МенеджерВТ = Неопределено)
	
	// Получим текст запроса выборки товаров из документа основания - создание ВТ ТоварыДокументаОснования
	ДополнительныеПараметрыЗапроса = Новый Структура;
	ДокументОснование              = МассивДокументов[0];
	МетаданныеДокументаОснования   = ДокументОснование.Метаданные();
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	НЕОПРЕДЕЛЕНО КАК Ссылка,
	|	ЛОЖЬ		 КАК ЭтоДвижениеПриход,
	|	НЕОПРЕДЕЛЕНО КАК Номенклатура,
	|	НЕОПРЕДЕЛЕНО КАК Характеристика,
	|	НЕОПРЕДЕЛЕНО КАК Серия,
	|	0 			 КАК Количество
	|ПОМЕСТИТЬ %1";
	
	Модуль.ПриОпределенииЗапросаТоварыДокументаОснования(
		МетаданныеДокументаОснования,
		МетаданныеДокументаИС,
		ТекстЗапроса,
		ДополнительныеПараметрыЗапроса);
		
	Если ТекстЗапроса = Неопределено Тогда
		
		УточнениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Неправильное встраивание расчета статуса оформления документа ""%1"" для документа ""%2"".'"),
				МетаданныеДокументаОснования.Имя,
				МетаданныеДокументаИС.Имя);
		
		ВызватьИсключение ИнтеграцияИСКлиентСервер.ТекстОшибки(,УточнениеОшибки);
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.Ссылка КАК Ссылка,
	|	СУММА(1) КАК КоличествоСтрок
	|ИЗ
	|	%1 КАК ТаблицаТовары
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ?(МенеджерВТ = Неопределено, Новый МенеджерВременныхТаблиц, МенеджерВТ);
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Для Каждого КлючИЗначение Из ДополнительныеПараметрыЗапроса Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Запрос.Текст = СтрШаблон(ТекстЗапроса, ИмяВременнойТаблицыДляВыборкиДанныхДокумента());
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Результат = ИнтеграцияИСКлиентСервер.МассивВСоответствие(МассивДокументов, 0);
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(Выборка.Ссылка, Выборка.КоличествоСтрок);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Служебная. Рассчитывает и записывает статусы оформления.
//
// Параметры:
//   МассивДокументов - Массив из ДокументСсылка, Справочникссылка - основания документов ГосИС.
//   ИсточникОбъект   - ДокументОбъект, Неопределено - записываемый документ-основание.
//   Модуль           - ОбщийМодуль - модуль, определяющий специфику подсистемы.
//
Процедура РассчитатьДляОснований(МассивДокументов, ИсточникОбъект, Модуль)
	
	Если НЕ ЗначениеЗаполнено(МассивДокументов) Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОснование = МассивДокументов[0];
	ТипДокументОснование = ТипЗнч(ДокументОснование);
	МетаданныеОснования = ДокументОснование.Метаданные();
	
	Если Не Модуль.ТипОснование().СодержитТип(ТипЗнч(ДокументОснование)) Тогда
		
		УточнениеОшибки = СтрШаблон(
			НСтр("ru='Ссылочный тип ""%1"" не входит в состав определяемого типа ""ОснованиеСтатусыОформленияДокументов"".'"),
			СокрЛП(ТипДокументОснование));
		
		ВызватьИсключение ИнтеграцияИСКлиентСервер.ТекстОшибки(, УточнениеОшибки);
		
	КонецЕсли;
	
	// Определим документы ГосИС, которые могут оформляться на основании ДокументОснование.
	ДокументыИС = Модуль.ИменаДокументовДляДокументаОснования(ДокументОснование);
	
	Если НЕ ЗначениеЗаполнено(ДокументыИС) Тогда
		
		УточнениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Ссылочный тип ""%1"" не входит в состав ни одного из определяемых типов оснований.'"),
			СокрЛП(ТипДокументОснование));
		
		ВызватьИсключение ИнтеграцияИСКлиентСервер.ТекстОшибки(, УточнениеОшибки); // ошибка составов определяемых типов Основание<ИмяДокументаВЕТИС>
		
	КонецЕсли;
	
	СводнаяТаблицаРеквизитов = Неопределено;
	// Заполним статус оформления для каждого документа ГосИС.
	Для Каждого ТекущийДокументИС Из ДокументыИС Цикл
		
		МетаданныеДокументаИС = Метаданные.Документы[ТекущийДокументИС];
		СтруктураРеквизитов = Модуль.РеквизитыДляРасчета(МетаданныеОснования, МетаданныеДокументаИС);
		МетаРеквизиты       = Модуль.МетаРеквизиты();
		
		СтруктураРеквизитов.Вставить("ДокументОснование", "Ссылка");
		СтруктураРеквизитов.Вставить("Документ", Документы[МетаданныеДокументаИС.Имя].ПустаяСсылка());
		
		ПредопределенныеЗначения = Новый Структура;
		СоставныеРеквизиты       = Новый Структура;
		ТаблицаРеквизитов        = Новый ТаблицаЗначений;
		ТаблицаРеквизитов.Колонки.Добавить("Документ", Модуль.ТипДокумент());
		ТаблицаРеквизитов.Колонки.Добавить("ДокументОснование", Модуль.ТипОснование());
		
		Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
			
			МетаРеквизит = МетаРеквизиты.Найти(КлючИЗначение.Ключ);
			
			Если МетаРеквизит = Неопределено Тогда
				Если КлючИЗначение.Ключ <> "Документ" И КлючИЗначение.Ключ <> "ДокументОснование" Тогда
					ТаблицаРеквизитов.Колонки.Добавить(КлючИЗначение.Ключ); // вспомогательный реквизит
				КонецЕсли;
			Иначе
				ТаблицаРеквизитов.Колонки.Добавить(КлючИЗначение.Ключ, МетаРеквизит.Тип); // реквизит регистра статусов
			КонецЕсли;
			
			Если ТипЗнч(КлючИЗначение.Значение) <> Тип("Строка") ИЛИ ПустаяСтрока(КлючИЗначение.Значение) Тогда
				// Значение уже определено в РеквизитыДляРасчета.
				ПредопределенныеЗначения.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
				СтруктураРеквизитов.Удалить(КлючИЗначение.Ключ);
			ИначеЕсли СтрНайти(КлючИЗначение.Значение, ",") > 0 Тогда
				ЗначенияПолей = СтрРазделить(КлючИЗначение.Значение, ",", Ложь);
				СоставныеРеквизиты.Вставить(КлючИЗначение.Ключ, ЗначенияПолей);
				Для Индекс = 0 По ЗначенияПолей.ВГраница() Цикл
					СтруктураРеквизитов.Вставить(КлючИЗначение.Ключ + Индекс, ЗначенияПолей[Индекс]);
				КонецЦикла;
				СтруктураРеквизитов.Удалить(КлючИЗначение.Ключ);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ИсточникОбъект <> Неопределено Тогда
			
			// Процедура вызвана из обработчика события записи документа-основания.
			// Прочитаем реквизиты из самого объекта документа-основания.
			
			СтрокаРеквизитов = ТаблицаРеквизитов.Добавить();
			
			Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
				СтруктураРеквизитов[КлючИЗначение.Ключ] = ЗначениеРеквизитаОбъекта(ИсточникОбъект, КлючИЗначение.Значение);
			КонецЦикла;
			ЗаполнитьЗначенияСвойств(СтрокаРеквизитов, СтруктураРеквизитов);
			
			Для Каждого КлючИЗначение Из СоставныеРеквизиты Цикл
				Для Индекс = 0 По КлючИЗначение.Значение.ВГраница() Цикл
					Если Не ЗначениеЗаполнено(СтрокаРеквизитов[КлючИЗначение.Ключ]) Тогда
						СтрокаРеквизитов[КлючИЗначение.Ключ] = СтруктураРеквизитов[КлючИЗначение.Ключ+Индекс];
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			
		Иначе
			
			// Прочитаем реквизиты документов-оснований из ИБ.
			СтруктураРеквизитовОснования = Новый Структура;
			СтруктураРеквизитовТЧОснования = Новый Структура;
			// Ограничение: не более 1 табличной части
			ТабличныеЧастиОснования = МетаданныеОснования.ТабличныеЧасти;
			ИмяТабличнойЧастиОснования = "";
			Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
				ПозицияРазделителя = СтрНайти(КлючИЗначение.Значение, ".");
				Если ПозицияРазделителя = 0 Тогда
					СтруктураРеквизитовОснования.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
				ИначеЕсли ТабличныеЧастиОснования.Найти(Лев(КлючИЗначение.Значение, ПозицияРазделителя-1)) <> Неопределено Тогда
					ИмяТабличнойЧастиОснования = Лев(КлючИЗначение.Значение, ПозицияРазделителя-1);
					СтруктураРеквизитовТЧОснования.Вставить(КлючИЗначение.Ключ, Сред(КлючИЗначение.Значение, ПозицияРазделителя+1));
				Иначе
					СтруктураРеквизитовОснования.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
				КонецЕсли;
			КонецЦикла;
			
			УстановитьПривилегированныйРежим(Истина);
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
			
			МассивСтрок = Новый Массив;
			МассивСтрок.Добавить("ВЫБРАТЬ");
			ШаблонСтрокиЗапроса =
			"
			|	Т.%1 КАК %2,";
			Для Каждого КлючИЗначение Из СтруктураРеквизитовОснования Цикл
				МассивСтрок.Добавить(СтрШаблон(ШаблонСтрокиЗапроса, КлючИЗначение.Значение, КлючИЗначение.Ключ));
			КонецЦикла;
			МассивСтрок.Добавить(СтрШаблон("
				|	Истина КАК СлужебноеПоле
				|ИЗ
				|	%1 КАК Т
				|ГДЕ
				|	Т.Ссылка В(&МассивДокументов)",
				МетаданныеОснования.ПолноеИмя()));
			Запрос.Текст = СтрСоединить(МассивСтрок);
			ЗначенияРеквизитов = Запрос.Выполнить().Выгрузить();
			
			Для Каждого РеквизитыДокумента Из ЗначенияРеквизитов Цикл
				
				СтрокаРеквизитов = ТаблицаРеквизитов.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРеквизитов, РеквизитыДокумента);
				
				Для Каждого КлючИЗначение Из СоставныеРеквизиты Цикл
					Если ЗначенияРеквизитов.Колонки.Найти(КлючИЗначение.Ключ+"0")<>Неопределено Тогда
						Для Индекс = 0 По КлючИЗначение.Значение.ВГраница() Цикл
							Если Не ЗначениеЗаполнено(СтрокаРеквизитов[КлючИЗначение.Ключ]) Тогда
								СтрокаРеквизитов[КлючИЗначение.Ключ] = РеквизитыДокумента[КлючИЗначение.Ключ+Индекс];
							КонецЕсли;
						КонецЦикла;;
					КонецЕсли;
				КонецЦикла;
				
			КонецЦикла;
			ТаблицаРеквизитов.Индексы.Добавить("ДокументОснование");
			
			Если ЗначениеЗаполнено(ИмяТабличнойЧастиОснования) Тогда
				
				МассивСтрок.Очистить();
				МассивСтрок.Добавить("ВЫБРАТЬ");
				Для Каждого КлючИЗначение Из СтруктураРеквизитовТЧОснования Цикл
					МассивСтрок.Добавить(СтрШаблон(ШаблонСтрокиЗапроса, КлючИЗначение.Значение, КлючИЗначение.Ключ));
				КонецЦикла;
				МассивСтрок.Добавить(СтрШаблон("
				|	Т.Ссылка КАК ДокументОснование
				|ИЗ
				|	%1.%2 КАК Т
				|ГДЕ
				|	Т.Ссылка В(&МассивДокументов)",
				МетаданныеОснования.ПолноеИмя(),
				ИмяТабличнойЧастиОснования));
				
				Запрос.Текст = СтрСоединить(МассивСтрок);
				ЗначенияРеквизитов = Запрос.Выполнить().Выгрузить();
				
				Для Каждого РеквизитыДокумента Из ЗначенияРеквизитов Цикл
				
					СтрокаРеквизитов = ТаблицаРеквизитов.Найти(РеквизитыДокумента.ДокументОснование, "ДокументОснование");
					ЗаполнитьЗначенияСвойств(СтрокаРеквизитов, РеквизитыДокумента);
					
					Для Каждого КлючИЗначение Из СоставныеРеквизиты Цикл
						Если ЗначенияРеквизитов.Колонки.Найти(КлючИЗначение.Ключ+"0")<>Неопределено Тогда
							Для Индекс = 0 По КлючИЗначение.Значение.ВГраница() Цикл
								Если Не ЗначениеЗаполнено(СтрокаРеквизитов[КлючИЗначение.Ключ]) Тогда
									СтрокаРеквизитов[КлючИЗначение.Ключ] = РеквизитыДокумента[КлючИЗначение.Ключ+Индекс];
								КонецЕсли;
							КонецЦикла;;
						КонецЕсли;
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЕсли;
			
			УстановитьПривилегированныйРежим(Ложь);
			
		КонецЕсли;
		
		// Заполним значения реквизитов, заданные явно.
		Для Каждого КлючИЗначение Из ПредопределенныеЗначения Цикл
			ТаблицаРеквизитов.ЗаполнитьЗначения(КлючИЗначение.Значение, КлючИЗначение.Ключ);
		КонецЦикла;
		
		Если СводнаяТаблицаРеквизитов = Неопределено Тогда
			СводнаяТаблицаРеквизитов = ТаблицаРеквизитов.Скопировать();
		Иначе
			Для Каждого СтрокаТаблицы Из ТаблицаРеквизитов Цикл
				ЗаполнитьЗначенияСвойств(СводнаяТаблицаРеквизитов.Добавить(), СтрокаТаблицы);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	Модуль.ЗаписатьДляОснований(СводнаяТаблицаРеквизитов);
	
КонецПроцедуры

Функция ЗначениеРеквизитаОбъекта(ИсточникОбъект, ИмяРеквизита)
	
	ЗначениеРеквизита = Неопределено;
	
	Если ИмяРеквизита = "" Тогда
		
	ИначеЕсли СтрНайти(ИмяРеквизита, ".") = 0 Тогда
		
		ЗначениеРеквизита = ИсточникОбъект[ИмяРеквизита];
		
	Иначе
		
		МассивИмен = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяРеквизита, ".",, Истина);
		
		Если ИсточникОбъект.Метаданные().ТабличныеЧасти.Найти(МассивИмен[0])<>Неопределено Тогда
			
			ТЧОбъекта = ИсточникОбъект[МассивИмен[0]];
			
			Если ТЧОбъекта.Количество() > 0 Тогда
				ЗначениеРеквизита = ТЧОбъекта[0][МассивИмен[1]];
			КонецЕсли;
			
		Иначе
			
			ЗначениеРеквизита = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсточникОбъект[МассивИмен[0]], МассивИмен[1]);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЗначениеРеквизита;
	
КонецФункции

#КонецОбласти