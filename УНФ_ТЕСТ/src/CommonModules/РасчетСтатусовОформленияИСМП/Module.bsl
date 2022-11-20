////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Механизм расчета статусов оформления документов ИСМП.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Для добавления нового документа-основания к документу ИСМП надо
//   - добавить ссылочный тип документа в определяемый тип с именем Основание<ИмяДокументаИСМП>
//   - добавить ссылочный тип документа в определяемый тип с именем ОснованиеСтатусыОформленияДокументовИСМП
//   - добавить объектный тип документа в определяемый тип с именем ОснованиеСтатусыОформленияДокументовИСМПОбъект
//
//   - дополнить процедуры общего модуля РасчетСтатусовОформленияИСМППереопределяемый
//     - ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаИСМП()
//     - ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаИСМП()
//
// Для подключения документа ИСМП к этому механизму нужно:
//   - добавить его ссылочный тип в определяемый тип ДокументыИСМППоддерживающиеСтатусыОформления
//   - добавить его объектный тип в определяемый тип ДокументыИСМППоддерживающиеСтатусыОформленияОбъект
//   - добавить его объектный тип в определяемый тип ОснованиеСтатусыОформленияДокументовИСМПОбъект
//
//   - добавить в документ реквизит с именем ДокументОснование
//   - создать определяемый тип с именем Основание<ИмяДокументаИСМП>
//     - заполнить этот тип ссылочными типами документов-оснований
//
//   - добавить типы из определяемого типа Основание<ИмяДокументаИСМП> в ОснованиеСтатусыОформленияДокументовИСМП
//   - добавить соответствующие ссылочным объектные типы из определяемого типа Основание<ИмяДокументаИСМП>
//      в ОснованиеСтатусыОформленияДокументовИСМПОбъект
//
//   - дополнить процедуры общего модуля РасчетСтатусовОформленияИСМППереопределяемый
//     - ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаИСМП()
//     - ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаИСМП()
//
#Область ПрограммныйИнтерфейс

#Область ОбработчикиПодписокНаСобытияИСМП

// Обработчик подписки на событие "Перед записью" документов ИС МП, поддерживающих статусы оформления.
// 
// Параметры:
//   Источник        - ОпределяемыйТип.ДокументыИСМППоддерживающиеСтатусыОформленияОбъект - записываемый объект
//   Отказ           - Булево - параметр, определяющий будет ли записываться объект
//   РежимЗаписи     - РежимЗаписиДокумента     - не используется
//   РежимПроведения - РежимПроведенияДокумента - не используется
//
Процедура РассчитатьСтатусОформленияИСМППередЗаписьюДокументаОбработчик(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	РасчетСтатусовОформленияИС.ПередЗаписьюДокумента("ВестиУчетМаркируемойПродукцииИСМП", Источник, Отказ);
	
КонецПроцедуры

// Обработчик подписки на событие "При записи" документов ИСМП, поддерживающих статусы оформления, и их документов-оснований.
//
// Параметры:
//   Источник - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовИСМПОбъект - записываемый объект.
//   Отказ    - Булево - параметр, определяющий будет ли записываться объект.
//
Процедура РассчитатьСтатусОформленияИСМППриЗаписиДокументаОбработчик(Источник, Отказ) Экспорт
	
	РасчетСтатусовОформленияИС.ПриЗаписиДокумента("ВестиУчетМаркируемойПродукцииИСМП", Источник, Отказ, РасчетСтатусовОформленияИСМП);
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Записывается документ ЭДО: расчет статуса надо выполнить для связанных с ним документов-оснований
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ЭлектронныйДокументИсходящий") Тогда
		ТребуетсяПересчет = Новый Массив;
		ЭлектронноеВзаимодействиеИСМППереопределяемый.ТребуетсяПересчетСтатусовОформления(Источник, ТребуетсяПересчет);
		Для Каждого ДокументыПоТипам Из ТребуетсяПересчет Цикл
			РассчитатьСтатусыОформленияДокументов(ДокументыПоТипам);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПересчетСтатусов

// Рассчитывает статусы оформления документов и записывает их в регистр сведений СтатусыОформленияДокументовИСМП.
//   ВАЖНО: все элементы массива Источники должны иметь одинаковый тип.
//
// Параметры:
//   Источники - Массив из ОпределяемыйТип.ДокументыИСМППоддерживающиеСтатусыОформления,
//                         ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовИСМП - источники события.
//
Процедура РассчитатьСтатусыОформленияДокументов(Источники) Экспорт
	
	Если Не РасчетСтатусовОформленияИС.РассчитатьДляДокументов("ВестиУчетМаркируемойПродукцииИСМП", Источники, РасчетСтатусовОформленияИСМП) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйнтерфейс

#Область ФункцииОбщегоМеханизма

//Возвращает признак, что документ ИС МП поддерживает статусы оформления (по метаданным)
//
//Параметры:
//   Источник - Произвольный - проверяемый объект
//
//Возвращаемое значение:
//   Булево - это документ ИС МП поддерживающий статус оформления
//
Функция ЭтоДокументПоддерживающийСтатусОформления(Источник) Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ДокументыИСМППоддерживающиеСтатусыОформленияОбъект.Тип.СодержитТип(ТипЗнч(Источник))
		ИЛИ Метаданные.ОпределяемыеТипы.ДокументыИСМППоддерживающиеСтатусыОформления.Тип.СодержитТип(ТипЗнч(Источник));
	
КонецФункции

//Возвращает признак, что проверяемый объект может являться основанием для документа ИС МП (по метаданным)
//
//Параметры:
//   Источник - Произвольный - проверяемый объект
//
//Возвращаемое значение:
//   Булево - это документ-основание для документа ИС МП.
//
Функция ЭтоДокументОснование(Источник) Экспорт
	
	Возврат ТипОснование().СодержитТип(ТипЗнч(Источник));
	
КонецФункции

//См. РасчетСтатусовОформленияИС.ИменаДокументовДляДокументаОснования.
//
//Возвращаемое значение:
//   Массив Из Строка - .
//
Функция ИменаДокументовДляДокументаОснования(ДокументОснование) Экспорт
	
	Возврат РасчетСтатусовОформленияИС.ИменаДокументовДляДокументаОснования(ДокументОснование, ТипДокумент());
	
КонецФункции

//Реквизиты регистра "Статусы оформления документов ИС МП"
//
//Возвращаемое значение:
//   Массив Из ОбъектМетаданных - реквизиты.
//
Функция МетаРеквизиты() Экспорт
	
	Возврат Метаданные.РегистрыСведений.СтатусыОформленияДокументовИСМП.Реквизиты;
	
КонецФункции

//Описание типов (документов) являющихся основаниями для оформления документов ИС МП.
//
//Возвращаемое значение:
//   ОписаниеТипов - тип основание.
//
Функция ТипОснование() Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ОснованиеСтатусыОформленияДокументовИСМП.Тип;
	
КонецФункции

//Описание типов (документов) ИС МП поддерживающих статус оформления.
//
//Возвращаемое значение:
//   ОписаниеТипов - тип документы ИС МП.
//
Функция ТипДокумент() Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ДокументыИСМППоддерживающиеСтатусыОформления.Тип;
	
КонецФункции

#КонецОбласти

#Область Статусы

// Рассчитывает статус оформления документа и записывает его в регистр сведений СтатусыОформленияДокументовИСМП.
//
// Параметры:
//   Источник - ОпределяемыйТип.ДокументыИСМППоддерживающиеСтатусыОформления, ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовИСМП, ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовИСМПОбъект - источник события расчета статуса.
//
Процедура РассчитатьСтатусОформленияДокумента(Источник) Экспорт
	
	Если Не РасчетСтатусовОформленияИС.РассчитатьДляДокумента("ВестиУчетМаркируемойПродукцииИСМП", Источник, РасчетСтатусовОформленияИСМП) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру с именами ключевых реквизитов документа-основания для документа ИСМП.
//   Значения этих реквизитов будут записаны в регистр сведений СтатусыОформленияДокументовИСМП.
//   Способ определения значения реквизита:
//     * Строка - имя реквизита документа-основания из которого следует взять значение (при обращении через
//     точку будет выполнено обращение к реквизиту первой строки одноименной ТЧ или к реквизиту реквизита основания);
//     * Произвольный - в т.ч. пустая строка - значение заполнения не зависящее от основания.
//
// Параметры:
//   МетаданныеОснования     - ОбъектМетаданных - метаданные документа-основания из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовИСМП
//   МетаданныеДокументаИСМП - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыИСМППоддерживающиеСтатусыОформления
//
// Возвращаемое значение:
//   Структура - имена реквизитов (в качестве типа приведен тип соответствующего реквизита):
//     * Проведен      - Булево - документ-основание проведен.
//     * Дата          - Дата   - дата основания.
//     * Номер         - Строка - номер основания.
//     * Ответственный - ОпределяемыйТип.Пользователь - пользователь, оформивший документ-основание; значение по умолчанию "Ответственный".
//     * Контрагент    - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - организация в документе-основании; значение по умолчанию "Организация".
//
Функция РеквизитыДляРасчета(МетаданныеОснования, МетаданныеДокументаИСМП) Экспорт

	Реквизиты = Новый Структура;

	// Стандартные реквизиты
	Реквизиты.Вставить("Проведен", "Проведен");
	Реквизиты.Вставить("Дата", "Дата");
	Реквизиты.Вставить("Номер", "Номер");
	// Переопределяемые реквизиты
	Реквизиты.Вставить("Ответственный", "Ответственный");
	Реквизиты.Вставить("Контрагент", "Организация");

	РасчетСтатусовОформленияИСМППереопределяемый.ПриОпределенииИменРеквизитовДляРасчетаСтатусаОформления(МетаданныеОснования, МетаданныеДокументаИСМП, Реквизиты);

	Возврат Реквизиты;

КонецФункции

//Позволяет определить текст и параметры запроса выборки данных из документов-основания для расчета статуса оформления. 
//
//Параметры:
//   МетаданныеОснования - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.Основание<Имя документа ИСМП>.
//   МетаданныеДокументаИСМП - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыИСМППоддерживающиеСтатусыОформления.
//   ТекстЗапроса - Строка - текст запроса выборки данных, который надо определить.
//   ПараметрыЗапроса - Структура - дополнительные параметры запроса, требуемые для выполнения запроса 
//       конкретного документа; при необходимости можно дополнить данную структуру.
//
Процедура ПриОпределенииЗапросаТоварыДокументаОснования(МетаданныеОснования, МетаданныеДокументаИСМП,
	ТекстЗапроса, ПараметрыЗапроса) Экспорт
	
	Если МетаданныеОснования = Метаданные.Документы.ПеремаркировкаТоваровИСМП Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ТаблицаТовары.Ссылка         КАК Ссылка,
		|	ИСТИНА                       КАК ЭтоДвижениеПриход,
		|	ТаблицаТовары.Номенклатура   КАК Номенклатура,
		|	ТаблицаТовары.Характеристика КАК Характеристика,
		|	НЕОПРЕДЕЛЕНО                 КАК Серия,
		|	СУММА(1)                     КАК Количество
		|ПОМЕСТИТЬ %1
		|ИЗ
		|	Документ.ПеремаркировкаТоваровИСМП.Товары КАК ТаблицаТовары
		|ГДЕ
		|	ТаблицаТовары.Ссылка В (&МассивДокументов)
		|	И ТаблицаТовары.НовыйКодМаркировки = ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.Пустаяссылка)
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаТовары.Ссылка,
		|	ТаблицаТовары.Номенклатура,
		|	ТаблицаТовары.Характеристика
		|";
	
	ИначеЕсли МетаданныеОснования = Метаданные.Документы.МаркировкаТоваровИСМП Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ВложенныйЗапрос.Ссылка            КАК Ссылка,
		|	ВложенныйЗапрос.Номенклатура      КАК Номенклатура,
		|	ВложенныйЗапрос.Характеристика    КАК Характеристика,
		|	ВложенныйЗапрос.Серия             КАК Серия,
		|	ИСТИНА                            КАК ЭтоДвижениеПриход,
		|	СУММА(ВложенныйЗапрос.Количество) КАК Количество
		|ПОМЕСТИТЬ %1
		|ИЗ
		|(
		|ВЫБРАТЬ
		|	ТаблицаТовары.Ссылка         КАК Ссылка,
		|	ТаблицаТовары.Номенклатура   КАК Номенклатура,
		|	ТаблицаТовары.Характеристика КАК Характеристика,
		|	ТаблицаТовары.Серия          КАК Серия,
		|	ТаблицаТовары.Количество     КАК Количество
		|ИЗ
		|	Документ.МаркировкаТоваровИСМП.Товары КАК ТаблицаТовары
		|ГДЕ
		|	ТаблицаТовары.Ссылка В (&МассивДокументов)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ШтрихкодыУпаковок.Ссылка КАК Ссылка,
		|	Штрихкоды.Номенклатура   КАК Номенклатура,
		|	Штрихкоды.Характеристика КАК Характеристика,
		|	Штрихкоды.Серия          КАК Серия,
		|	-ВЫБОР КОГДА Штрихкоды.Количество = 0 ТОГДА 1 ИНАЧЕ Штрихкоды.Количество КОНЕЦ КАК Количество
		|ИЗ
		|	Документ.МаркировкаТоваровИСМП.ШтрихкодыУпаковок КАК ШтрихкодыУпаковок
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШтрихкодыУпаковокТоваров КАК Штрихкоды
		|	ПО Штрихкоды.Ссылка = ШтрихкодыУпаковок.ШтрихкодУпаковки
		|ГДЕ
		|	ШтрихкодыУпаковок.Ссылка В (&МассивДокументов)
		|) КАК ВложенныйЗапрос
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.Ссылка,
		|	ВложенныйЗапрос.Номенклатура,
		|	ВложенныйЗапрос.Характеристика,
		|	ВложенныйЗапрос.Серия
		|ИМЕЮЩИЕ
		|	СУММА(ВложенныйЗапрос.Количество) > 0
		|
		|";
	
	КонецЕсли;
	
	РасчетСтатусовОформленияИСМППереопределяемый.ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформления(
		МетаданныеОснования, МетаданныеДокументаИСМП, ТекстЗапроса, ПараметрыЗапроса);
	
КонецПроцедуры

// Определяет текущий статус оформления документов ИСМП.
//
//Параметры:
//   МассивДокументов        - Массив Из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовИСМП - документы-основание для документа ИСМП
//   МетаданныеДокументаИСМП - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыИСМППоддерживающиеСтатусыОформления
//   МенеджерВТ              - МенеджерВременныхТаблиц - (см. СформироватьТаблицуТоварыДокументовОснования)
//
// Возвращаемое значение:
//   Соответствие - 
//     Ключ     - элемент параметра МассивДокументов
//     Значение - Структура с полями:
//       СтатусОформления         - статус оформления объекта,
//       ДополнительнаяИнформация - информация для отладки.
//
Функция ОпределитьСтатусыОформленияДокументов(МассивДокументов, МетаданныеДокументаИСМП, МенеджерВТ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	// Соберем текст запроса выборки данных для определения статуса оформления документа ИСМП.
	Если МетаданныеДокументаИСМП = Метаданные.Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ Тогда
		
		ШаблонЗапросаВТОформленныеДокументы =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПулКодовМаркировки.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ОформленныеОснования%1
		|ИЗ
		|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ПулКодовМаркировки
		|ГДЕ
		|	ПулКодовМаркировки.ДокументОснование В (&МассивДокументов)
		|ИНДЕКСИРОВАТЬ ПО
		|	ДокументОснование
		|;
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаказНаЭмиссиюКодовМаркировкиСУЗ.ДокументОснование КАК ДокументОснование,
		|	ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ОформленныеДокументы%1
		|ИЗ
		|	Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ КАК ЗаказНаЭмиссиюКодовМаркировкиСУЗ
		|ГДЕ
		|	ЗаказНаЭмиссиюКодовМаркировкиСУЗ.ДокументОснование В (&МассивДокументов)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка";
		
	Иначе
	
	ШаблонЗапросаВТОформленныеДокументы = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокументы.Ссылка КАК Ссылка,
		|	ТаблицаДокументы.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ОформленныеДокументы%1
		|ИЗ
		|	Документ.%1 КАК ТаблицаДокументы
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовИСМП КАК Статусы
		|		ПО Статусы.Документ = ТаблицаДокументы.Ссылка
		|ГДЕ
		|	ТаблицаДокументы.ДокументОснование В (&МассивДокументов)
		|	И ТаблицаДокументы.Проведен
		|	И НЕ Статусы.Статус В (&КонечныеСтатусы%1)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка";
	
	КонецЕсли;
	
	ШаблонЗапросаОформленныеТоварыПоПулу = "
	|//////////////////////Коды маркировки по чужим заказам////////////////////////////////////////////////
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОформленныеТовары.ДокументОснование КАК ДокументОснование,
	|	ИСТИНА                              КАК ЭтоДвижениеПриход,
	|	ОформленныеТовары.Номенклатура      КАК Номенклатура,
	|	ОформленныеТовары.Характеристика    КАК Характеристика,
	|	Неопределено                        КАК Серия,
	|	0                                   КАК План,
	|	1                                   КАК Факт
	|ИЗ
	|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ОформленныеТовары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеОснования%1 КАК ОформленныеДокументы
	|	ПО ОформленныеТовары.ДокументОснование = ОформленныеДокументы.ДокументОснование
	|ГДЕ
	|	ОформленныеТовары.ЗаказНаЭмиссию.ДокументОснование <> ОформленныеДокументы.ДокументОснование
	|	И ОформленныеТовары.Шаблон <> ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.БлокТабачныхПачек)
	|	И ОформленныеТовары.Шаблон <> ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.АльтернативныйТабакБлок)
	|
	|//////////////////////Коды маркировки по своим заказам////////////////////////////////////////////////
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОформленныеДокументы.ДокументОснование,
	|	ИСТИНА,
	|	ОформленныеТовары.Номенклатура,
	|	ОформленныеТовары.Характеристика,
	|	Неопределено,
	|	0,
	|	Количество
	|ИЗ
	|	Документ.%1.Товары КАК ОформленныеТовары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
	|		ПО ОформленныеДокументы.Ссылка = ОформленныеТовары.Ссылка
	|ГДЕ
	|	ОформленныеТовары.Шаблон <> ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.БлокТабачныхПачек)
	|	И ОформленныеТовары.Шаблон <> ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.АльтернативныйТабакБлок)
	|
	|//////////////////////Свои коды маркировки отданные по чужим заказам считать не нужно/////////////////
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОформленныеДокументы.ДокументОснование,
	|	ИСТИНА,
	|	ОформленныеТовары.Номенклатура,
	|	ОформленныеТовары.Характеристика,
	|	Неопределено,
	|	0,
	|	-1
	|ИЗ
	|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ОформленныеТовары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
	|		ПО ОформленныеТовары.ЗаказНаЭмиссию = ОформленныеДокументы.Ссылка
	|ГДЕ
	|	ОформленныеТовары.ДокументОснование <> ОформленныеДокументы.ДокументОснование
	|	И ОформленныеТовары.Шаблон <> ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.БлокТабачныхПачек)
	|	И ОформленныеТовары.Шаблон <> ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.АльтернативныйТабакБлок)
	|";
	
	ШаблонЗапросаОформленныеТовары = "
		|	ВЫБРАТЬ
		|		ОформленныеДокументы.ДокументОснование КАК ДокументОснование,
		|		%3 КАК ЭтоДвижениеПриход,
		|		ОформленныеТовары.Номенклатура   КАК Номенклатура,
		|		ОформленныеТовары.Характеристика КАК Характеристика,
		|		ОформленныеТовары.Серия          КАК Серия,
		|		0                                КАК План,
		|		ВЫБОР КОГДА ОформленныеТовары.%4 < 0 ТОГДА -1 ИНАЧЕ 1 КОНЕЦ * ОформленныеТовары.%4 КАК Факт
		|	ИЗ
		|		Документ.%1.%2 КАК ОформленныеТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
		|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка";

	ШаблонЗапросаОформленныеТоварыБезСерийБезКоличества = "
		|	ВЫБРАТЬ
		|		ОформленныеДокументы.ДокументОснование КАК ДокументОснование,
		|		%3 КАК ЭтоДвижениеПриход,
		|		ОформленныеТовары.Номенклатура   КАК Номенклатура,
		|		ОформленныеТовары.Характеристика КАК Характеристика,
		|		Неопределено                     КАК Серия,
		|		0                                КАК План,
		|		1                                КАК Факт
		|	ИЗ
		|		Документ.%1.%2 КАК ОформленныеТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
		|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка";

	ШаблонРазделительЗапросов = "
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|";

	ТекстЗапросаОформленныеТовары = "";

	ИмяДокументаИСМП = МетаданныеДокументаИСМП.Имя;

	ЭтоДвижениеПриход = "ИСТИНА";

	ТекстЗапросаВТОформленныеДокументы = СтрШаблон(ШаблонЗапросаВТОформленныеДокументы, ИмяДокументаИСМП) + ШаблонРазделительЗапросов;

	Если МетаданныеДокументаИСМП = Метаданные.Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ Тогда
	
		ТекстЗапросаОформленныеТовары = ТекстЗапросаОформленныеТовары
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонЗапросаОформленныеТоварыПоПулу,
				ИмяДокументаИСМП);
		
	ИначеЕсли МетаданныеДокументаИСМП = Метаданные.Документы.ПеремаркировкаТоваровИСМП Тогда 
		
		ТекстЗапросаОформленныеТовары = ТекстЗапросаОформленныеТовары
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонЗапросаОформленныеТоварыБезСерийБезКоличества,
				ИмяДокументаИСМП,
				"Товары",
				ЭтоДвижениеПриход);
		
	Иначе
		
		ТекстЗапросаОформленныеТовары = ТекстЗапросаОформленныеТовары
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонЗапросаОформленныеТовары,
				ИмяДокументаИСМП,
				"Товары",
				ЭтоДвижениеПриход,
				"Количество");
		
	КонецЕсли;

	Запрос.УстановитьПараметр("КонечныеСтатусы"
		+ ИмяДокументаИСМП, Документы[ИмяДокументаИСМП].КонечныеСтатусы());

	ЧастиЗапроса = Новый Массив;
	ЧастиЗапроса.Добавить(ТекстЗапросаВТОформленныеДокументы);
	ЧастиЗапроса.Добавить("
		|ВЫБРАТЬ
		|	ТоварыКОформлению.ДокументОснование КАК ДокументОснование,
		|	ТоварыКОформлению.ЭтоДвижениеПриход КАК ЭтоДвижениеПриход,
		|	ТоварыКОформлению.Номенклатура      КАК Номенклатура,
		|	ТоварыКОформлению.Характеристика    КАК Характеристика,
		|	ТоварыКОформлению.Серия             КАК Серия,
		|	СУММА(ТоварыКОформлению.План)       КАК План,
		|	СУММА(ТоварыКОформлению.Факт)       КАК Факт
		|ПОМЕСТИТЬ Результат
		|ИЗ
		|	(ВЫБРАТЬ
		|		Товары.Ссылка            КАК ДокументОснование,
		|		Товары.ЭтоДвижениеПриход КАК ЭтоДвижениеПриход,
		|		Товары.Номенклатура      КАК Номенклатура,
		|		Товары.Характеристика    КАК Характеристика,
		|		Товары.Серия             КАК Серия,
		|		Товары.Количество        КАК План,
		|		0                        КАК Факт
		|	ИЗ
		|		" + РасчетСтатусовОформленияИС.ИмяВременнойТаблицыДляВыборкиДанныхДокумента() + " КАК Товары
		|	ОБЪЕДИНИТЬ ВСЕ
		|");
	ЧастиЗапроса.Добавить(ТекстЗапросаОформленныеТовары);
	ЧастиЗапроса.Добавить("
		|	) КАК ТоварыКОформлению
		|СГРУППИРОВАТЬ ПО
		|	ТоварыКОформлению.ДокументОснование,
		|	ТоварыКОформлению.ЭтоДвижениеПриход,
		|	ТоварыКОформлению.Номенклатура,
		|	ТоварыКОформлению.Характеристика,
		|	ТоварыКОформлению.Серия
		|");
	ЧастиЗапроса.Добавить(ШаблонРазделительЗапросов);
	ЧастиЗапроса.Добавить("
		|ВЫБРАТЬ
		|	Т.ДокументОснование КАК ДокументОснование,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.Факт > 0 И Т.План > 0       ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.Факт >= 0 И Т.План > Т.Факт ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьНеОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.План <= Т.Факт              ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьПолностьюОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.План < Т.Факт               ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьОшибкиОформления
		|ПОМЕСТИТЬ РезультатПоДокументам
		|ИЗ
		|	Результат КАК Т
		|СГРУППИРОВАТЬ ПО
		|	Т.ДокументОснование");
	ЧастиЗапроса.Добавить(ШаблонРазделительЗапросов);
	ЧастиЗапроса.Добавить("
		|ВЫБРАТЬ
		|	Т.ДокументОснование КАК ДокументОснование,
		|	ВЫБОР
		|		КОГДА Т.ЕстьОшибкиОформления
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.ЕстьОшибкиОформления)
		|		КОГДА Т.ЕстьПолностьюОформленныеТовары И НЕ Т.ЕстьНеОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.Оформлено)
		|		КОГДА Т.ЕстьПолностьюОформленныеТовары И Т.ЕстьНеОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.ОформленоЧастично)
		|		КОГДА Т.ЕстьОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.ОформленоЧастично)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.НеОформлено)
		|	КОНЕЦ КАК СтатусОформления
		|ИЗ
		|	РезультатПоДокументам КАК Т");

	Запрос.Текст = СтрСоединить(ЧастиЗапроса);

	// Получим данные и определим статус оформления документа ИСМП.
	СтатусОформления = Новый Структура("СтатусОформления, ДополнительнаяИнформация", Перечисления.СтатусыОформленияДокументовГосИС.НеОформлено, Неопределено);

	Результат = ИнтеграцияИСКлиентСервер.МассивВСоответствие(МассивДокументов, СтатусОформления);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);

	Запрос.Текст = "ВЫБРАТЬ * ИЗ Результат КАК Т ГДЕ Т.ДокументОснование = &ДокументОснование";

	Пока Выборка.Следующий() Цикл

		Запрос.УстановитьПараметр("ДокументОснование", Выборка.ДокументОснование);

		// Сохраним данные, использовавшиеся для расчета статуса.
		УстановитьПривилегированныйРежим(Истина);
		ТаблицаДляРасчетаСтатуса = Запрос.Выполнить().Выгрузить();
		УстановитьПривилегированныйРежим(Ложь);

		ТаблицаДляРасчетаСтатуса.Колонки.ЭтоДвижениеПриход.Заголовок = НСтр("ru='Приходное движение'");
		ТаблицаДляРасчетаСтатуса.Колонки.План.Заголовок = НСтр("ru='По документу-основанию'");
		ТаблицаДляРасчетаСтатуса.Колонки.Факт.Заголовок = НСтр("ru='По документу ИСМП'");

		ДополнительнаяИнформация = Новый ХранилищеЗначения(ТаблицаДляРасчетаСтатуса, Новый СжатиеДанных(9));
		
		СтатусОформления = Новый Структура("СтатусОформления, ДополнительнаяИнформация", Выборка.СтатусОформления, ДополнительнаяИнформация);
		
		// Особенности: заказ кодов маркировки возможен по перемаркировке и вводу в оборот по отсутствующим кодам, 
		//  но он не может быть в статусе ЕстьОшибкиОформления по этим документам
		// (после получения кодов они будут использованы в документе ИСМП изменив ожидаемое количество)
		Если Выборка.СтатусОформления = Перечисления.СтатусыОформленияДокументовГосИС.ЕстьОшибкиОформления Тогда
			
			ТипОснования = ТипЗнч(Выборка.ДокументОснование);
			Если ТипОснования = Тип("ДокументСсылка.МаркировкаТоваровИСМП")
				Или ТипОснования = Тип("ДокументСсылка.ПеремаркировкаТоваровИСМП") Тогда
				
				СтатусОформления.СтатусОформления = Перечисления.СтатусыОформленияДокументовГосИС.Оформлено;
				
			КонецЕсли;
		КонецЕсли;
		
		Результат.Вставить(Выборка.ДокументОснование, СтатусОформления);

	КонецЦикла;

	Возврат Результат;

КонецФункции

//Служебная. Рассчитывает и записывает статусы оформления. Специфика ИС МП.
//
//Параметры:
//   ТаблицаРеквизитов - ТаблицаЗначений - собранные общим механизмом реквизиты для записи статуса
//
Процедура ЗаписатьДляОснований(ТаблицаРеквизитов) Экспорт

	// Запишем статус оформления документа ИСМП.
	РасчетСтатусовОформленияИС.ЗаписатьСтатусОформленияДокументов(
		ТаблицаРеквизитов,
		РегистрыСведений.СтатусыОформленияДокументовИСМП,
		РасчетСтатусовОформленияИСМП);

КонецПроцедуры

//Возвращает признак необходимости записи в регистр "Статусы оформления документов ИС МП"
//
//Параметры:
//   ДокументОснование  - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовИСМП - записываемый в регистр документ-основание.
//   Реквизиты - См. РеквизитыДляРасчета - влияющие на запись значения реквизитов основания.
//   КоличествоСтрокДокументовОснования - Соответствие - количество строк основания требующих оформления.
//   ДополнительныеПараметры - Неопределено - не используется в подсистеме
//
//Возвращаемое значение:
//   Булево - признак необходимости записи
//
Функция ТребуетсяОформление(ДокументОснование, Реквизиты, КоличествоСтрокДокументовОснования, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ЗначениеЗаполнено(КоличествоСтрокДокументовОснования[ДокументОснование]);
	
КонецФункции

#КонецОбласти

#КонецОбласти
