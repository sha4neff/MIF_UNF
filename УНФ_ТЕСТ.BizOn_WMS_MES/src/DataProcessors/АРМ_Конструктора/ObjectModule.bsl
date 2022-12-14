Функция ПолучитьТЗОчередьЗаказов(Отказ) Экспорт
	
	вхДатаЗапроса = ТекущаяДата();

	Запрос = Новый Запрос;
	Запрос.Текст = 	


//"ВЫБРАТЬ
//|	ТоварыВПроизводствеОстатки.ДокументОснование КАК ЗаказНаПроизводство,
//|	ТоварыВПроизводствеОстатки.Номенклатура КАК Номенклатура,
//|	ТоварыВПроизводствеОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
//|	ТоварыВПроизводствеОстатки.КоличествоОстаток КАК НужноПроизвести,
//|	ТоварыВПроизводствеОстатки.Номенклатура.ЕдиницаХраненияОстатков.Ширина КАК РазмерX,
//|	ТоварыВПроизводствеОстатки.Номенклатура.ЕдиницаХраненияОстатков.Высота КАК РазмерY,
//|	ТоварыВПроизводствеОстатки.Номенклатура.ЕдиницаХраненияОстатков.Глубина КАК РазмерZ,
//|	ТоварыВПроизводствеОстатки.Номенклатура.ЕдиницаХраненияОстатков.Вес КАК Вес,
//|	ТоварыВПроизводствеОстатки.Номенклатура.ЕдиницаХраненияОстатков.Объем КАК Объем,
//|	ТоварыВПроизводствеОстатки.ДокументОснование.Дата КАК ЗаказНаПроизводствоДата,
//|	ТоварыВПроизводствеОстатки.Номенклатура.Наименование КАК НоменклатураНаименование,
//|	ТоварыВПроизводствеОстатки.ХарактеристикаНоменклатуры.Наименование КАК ХарактеристикаНаименование,
//|	ТоварыВПроизводствеОстатки.Подразделение КАК Подразделение,
//|	ТоварыВПроизводствеОстатки.СкладСборки КАК СкладСборки,
//|	ТоварыВПроизводствеОстатки.Организация КАК Организация,
//|	""          "" КАК ТипСтроки,
//|	ТоварыВПроизводствеОстатки.КоличествоОстаток КАК Количество,
//|	ТоварыВПроизводствеОстатки.ДокументОснование.Рекламация КАК ЭтоРекламация,
//|	ТоварыВПроизводствеОстатки.ДокументОснование.Инициатор КАК Инициатор,
//|	ТоварыВПроизводствеОстатки.ДокументОснование.Дата КАК ИнициаторДата
//|ПОМЕСТИТЬ ОчередьЗаказов
//|ИЗ
//|	РегистрНакопления.ТоварыВПроизводстве.Остатки(
//|			&вхДатаЗапроса,
//|			Подразделение = &Подразделение
//|				И ДокументОснование ССЫЛКА Документ.ЗаказНаПроизводство) КАК ТоварыВПроизводствеОстатки
//|
//|ИНДЕКСИРОВАТЬ ПО
//|	Номенклатура
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	ОчередьЗаказов.Номенклатура КАК Номенклатура,
//|	ОчередьЗаказов.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
//|ПОМЕСТИТЬ НоменклатураЗаказов
//|ИЗ
//|	ОчередьЗаказов КАК ОчередьЗаказов
//|
//|СГРУППИРОВАТЬ ПО
//|	ОчередьЗаказов.Номенклатура,
//|	ОчередьЗаказов.ХарактеристикаНоменклатуры
//|
//|ИНДЕКСИРОВАТЬ ПО
//|	Номенклатура
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры,
//|	ВЫБОР
//|		КОГДА ЕСТЬNULL(БЗ_МаршрутныеКартыОперацииСрезПоследних.Количество, 0) > 0
//|			ТОГДА ИСТИНА
//|		ИНАЧЕ ЛОЖЬ
//|	КОНЕЦ КАК ЕстьРезка,
//|	1 КАК ПриоритетТЗ
//|ПОМЕСТИТЬ НоменклатураЗаказовРезкаВыборМК
//|ИЗ
//|	НоменклатураЗаказов КАК НоменклатураЗаказов
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.БЗ_МаршрутныеКартыОперации.СрезПоследних(
//|				,
//|				Участок.Подразделение = &Подразделение
//|					И ВидПартии = &ВидПартии
//|					И Операция.ВидОперации = ЗНАЧЕНИЕ(Перечисление.БЗ_ВидТехнологическойОперации.РезкаЗапуск)) КАК БЗ_МаршрутныеКартыОперацииСрезПоследних
//|		ПО НоменклатураЗаказов.Номенклатура = БЗ_МаршрутныеКартыОперацииСрезПоследних.Номенклатура
//|			И НоменклатураЗаказов.ХарактеристикаНоменклатуры = БЗ_МаршрутныеКартыОперацииСрезПоследних.ХарактеристикаНоменклатуры
//|
//|СГРУППИРОВАТЬ ПО
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры,
//|	ВЫБОР
//|		КОГДА ЕСТЬNULL(БЗ_МаршрутныеКартыОперацииСрезПоследних.Количество, 0) > 0
//|			ТОГДА ИСТИНА
//|		ИНАЧЕ ЛОЖЬ
//|	КОНЕЦ
//|
//|ОБЪЕДИНИТЬ ВСЕ
//|
//|ВЫБРАТЬ
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры,
//|	ВЫБОР
//|		КОГДА ЕСТЬNULL(БЗ_МаршрутныеКартыОперацииСрезПоследних.Количество, 0) > 0
//|			ТОГДА ИСТИНА
//|		ИНАЧЕ ЛОЖЬ
//|	КОНЕЦ,
//|	5
//|ИЗ
//|	НоменклатураЗаказов КАК НоменклатураЗаказов
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.БЗ_МаршрутныеКартыОперации.СрезПоследних(
//|				,
//|				Участок.Подразделение = &Подразделение
//|					И ВидПартии = ЗНАЧЕНИЕ(Справочник.БЗ_ВидыПартииПроизводства.ПустаяСсылка)
//|					И Операция.ВидОперации = ЗНАЧЕНИЕ(Перечисление.БЗ_ВидТехнологическойОперации.РезкаЗапуск)) КАК БЗ_МаршрутныеКартыОперацииСрезПоследних
//|		ПО НоменклатураЗаказов.Номенклатура = БЗ_МаршрутныеКартыОперацииСрезПоследних.Номенклатура
//|			И НоменклатураЗаказов.ХарактеристикаНоменклатуры = БЗ_МаршрутныеКартыОперацииСрезПоследних.ХарактеристикаНоменклатуры
//|
//|СГРУППИРОВАТЬ ПО
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры,
//|	ВЫБОР
//|		КОГДА ЕСТЬNULL(БЗ_МаршрутныеКартыОперацииСрезПоследних.Количество, 0) > 0
//|			ТОГДА ИСТИНА
//|		ИНАЧЕ ЛОЖЬ
//|	КОНЕЦ
//|
//|ОБЪЕДИНИТЬ ВСЕ
//|
//|ВЫБРАТЬ
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры,
//|	ЛОЖЬ,
//|	100
//|ИЗ
//|	НоменклатураЗаказов КАК НоменклатураЗаказов
//|
//|СГРУППИРОВАТЬ ПО
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры,
//|	НоменклатураЗаказов.Номенклатура
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры,
//|	20 КАК ПриоритетТЗ,
//|	МАКСИМУМ(БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.ШаблонТехнологическогоПроцесса) КАК ШаблонТехнологическогоПроцесса
//|ПОМЕСТИТЬ ВыборШаблонаТП
//|ИЗ
//|	НоменклатураЗаказов КАК НоменклатураЗаказов
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.БЗ_ШаблоныТехнологическихПроцессов.СрезПоследних(
//|				,
//|				(Участок = ЗНАЧЕНИЕ(Справочник.БЗ_Участки.ПустаяСсылка)
//|					ИЛИ Участок.Подразделение = &Подразделение)
//|					И ВидПартии = &ВидПартии) КАК БЗ_ШаблоныТехнологическихПроцессовСрезПоследних
//|		ПО НоменклатураЗаказов.Номенклатура = БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.Номенклатура
//|			И (ВЫБОР
//|				КОГДА БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.ХарактеристикаНоменклатуры = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.пустаяСсылка)
//|					ТОГДА ИСТИНА
//|				ИНАЧЕ БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.ХарактеристикаНоменклатуры = НоменклатураЗаказов.ХарактеристикаНоменклатуры
//|			КОНЕЦ)
//|
//|СГРУППИРОВАТЬ ПО
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры
//|
//|ОБЪЕДИНИТЬ ВСЕ
//|
//|ВЫБРАТЬ
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры,
//|	25,
//|	МАКСИМУМ(БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.ШаблонТехнологическогоПроцесса)
//|ИЗ
//|	НоменклатураЗаказов КАК НоменклатураЗаказов
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.БЗ_ШаблоныТехнологическихПроцессов.СрезПоследних(
//|				,
//|				Участок = ЗНАЧЕНИЕ(Справочник.БЗ_Участки.ПустаяСсылка)
//|					ИЛИ Участок.Подразделение = &Подразделение) КАК БЗ_ШаблоныТехнологическихПроцессовСрезПоследних
//|		ПО НоменклатураЗаказов.Номенклатура = БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.Номенклатура
//|			И (ВЫБОР
//|				КОГДА БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.ХарактеристикаНоменклатуры = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.пустаяСсылка)
//|					ТОГДА ИСТИНА
//|				ИНАЧЕ БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.ХарактеристикаНоменклатуры = НоменклатураЗаказов.ХарактеристикаНоменклатуры
//|			КОНЕЦ)
//|
//|СГРУППИРОВАТЬ ПО
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры
//|
//|ОБЪЕДИНИТЬ ВСЕ
//|
//|ВЫБРАТЬ
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры,
//|	30,
//|	МАКСИМУМ(БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.ШаблонТехнологическогоПроцесса)
//|ИЗ
//|	НоменклатураЗаказов КАК НоменклатураЗаказов
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.БЗ_ШаблоныТехнологическихПроцессов.СрезПоследних(
//|				,
//|				(Участок = ЗНАЧЕНИЕ(Справочник.БЗ_Участки.ПустаяСсылка)
//|					ИЛИ Участок.Подразделение = &Подразделение)
//|					И ВидПартии = &ВидПартии) КАК БЗ_ШаблоныТехнологическихПроцессовСрезПоследних
//|		ПО НоменклатураЗаказов.Номенклатура.НоменклатурнаяГруппаПроизводство = БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.НоменклатурнаяГруппаПроизводство
//|
//|СГРУППИРОВАТЬ ПО
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры
//|
//|ОБЪЕДИНИТЬ ВСЕ
//|
//|ВЫБРАТЬ
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры,
//|	35,
//|	МАКСИМУМ(БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.ШаблонТехнологическогоПроцесса)
//|ИЗ
//|	НоменклатураЗаказов КАК НоменклатураЗаказов
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.БЗ_ШаблоныТехнологическихПроцессов.СрезПоследних(
//|				,
//|				Участок = ЗНАЧЕНИЕ(Справочник.БЗ_Участки.ПустаяСсылка)
//|					ИЛИ Участок.Подразделение = &Подразделение) КАК БЗ_ШаблоныТехнологическихПроцессовСрезПоследних
//|		ПО НоменклатураЗаказов.Номенклатура.НоменклатурнаяГруппаПроизводство = БЗ_ШаблоныТехнологическихПроцессовСрезПоследних.НоменклатурнаяГруппаПроизводство
//|
//|СГРУППИРОВАТЬ ПО
//|	НоменклатураЗаказов.Номенклатура,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	ВыборШаблонаТП.Номенклатура,
//|	ВыборШаблонаТП.ХарактеристикаНоменклатуры,
//|	МИНИМУМ(ВыборШаблонаТП.ПриоритетТЗ) КАК ПриоритетТЗ
//|ПОМЕСТИТЬ ВыборШаблонаТПИтог
//|ИЗ
//|	ВыборШаблонаТП КАК ВыборШаблонаТП
//|
//|СГРУППИРОВАТЬ ПО
//|	ВыборШаблонаТП.Номенклатура,
//|	ВыборШаблонаТП.ХарактеристикаНоменклатуры
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	НоменклатураЗаказовРезкаВыборМК.Номенклатура КАК Номенклатура,
//|	НоменклатураЗаказовРезкаВыборМК.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
//|	НоменклатураЗаказовРезкаВыборМК.ПриоритетТЗ КАК ПриоритетТЗ,
//|	НоменклатураЗаказовРезкаВыборМК.ЕстьРезка
//|ПОМЕСТИТЬ НоменклатураЗаказовРезкаВыбор
//|ИЗ
//|	НоменклатураЗаказовРезкаВыборМК КАК НоменклатураЗаказовРезкаВыборМК
//|
//|СГРУППИРОВАТЬ ПО
//|	НоменклатураЗаказовРезкаВыборМК.Номенклатура,
//|	НоменклатураЗаказовРезкаВыборМК.ЕстьРезка,
//|	НоменклатураЗаказовРезкаВыборМК.ХарактеристикаНоменклатуры,
//|	НоменклатураЗаказовРезкаВыборМК.ПриоритетТЗ
//|
//|ОБЪЕДИНИТЬ ВСЕ
//|
//|ВЫБРАТЬ
//|	ВыборШаблонаТП.Номенклатура,
//|	ВыборШаблонаТП.ХарактеристикаНоменклатуры,
//|	ВыборШаблонаТП.ПриоритетТЗ,
//|	ВЫБОР
//|		КОГДА БЗ_ШаблонТехнологическогоПроцессаОперации.Количество > 0
//|			ТОГДА ИСТИНА
//|		ИНАЧЕ ЛОЖЬ
//|	КОНЕЦ
//|ИЗ
//|	ВыборШаблонаТП КАК ВыборШаблонаТП
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.БЗ_ШаблонТехнологическогоПроцесса.Операции КАК БЗ_ШаблонТехнологическогоПроцессаОперации
//|		ПО ВыборШаблонаТП.ШаблонТехнологическогоПроцесса = БЗ_ШаблонТехнологическогоПроцессаОперации.Ссылка
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВыборШаблонаТПИтог КАК ВыборШаблонаТПИтог
//|		ПО ВыборШаблонаТП.Номенклатура = ВыборШаблонаТПИтог.Номенклатура
//|			И ВыборШаблонаТП.ХарактеристикаНоменклатуры = ВыборШаблонаТПИтог.ХарактеристикаНоменклатуры
//|			И ВыборШаблонаТП.ПриоритетТЗ = ВыборШаблонаТПИтог.ПриоритетТЗ
//|ГДЕ
//|	БЗ_ШаблонТехнологическогоПроцессаОперации.Участок.Подразделение = &Подразделение
//|	И БЗ_ШаблонТехнологическогоПроцессаОперации.Операция.ВидОперации = ЗНАЧЕНИЕ(Перечисление.БЗ_ВидТехнологическойОперации.РезкаЗапуск)
//|
//|СГРУППИРОВАТЬ ПО
//|	ВыборШаблонаТП.ХарактеристикаНоменклатуры,
//|	ВЫБОР
//|		КОГДА БЗ_ШаблонТехнологическогоПроцессаОперации.Количество > 0
//|			ТОГДА ИСТИНА
//|		ИНАЧЕ ЛОЖЬ
//|	КОНЕЦ,
//|	ВыборШаблонаТП.Номенклатура,
//|	ВыборШаблонаТП.ПриоритетТЗ
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	НоменклатураЗаказовРезкаВыбор.Номенклатура,
//|	НоменклатураЗаказовРезкаВыбор.ХарактеристикаНоменклатуры,
//|	МИНИМУМ(НоменклатураЗаказовРезкаВыбор.ПриоритетТЗ) КАК ПриоритетТЗ
//|ПОМЕСТИТЬ НоменклатураЗаказовРезкаВыборИтог
//|ИЗ
//|	НоменклатураЗаказовРезкаВыбор КАК НоменклатураЗаказовРезкаВыбор
//|
//|СГРУППИРОВАТЬ ПО
//|	НоменклатураЗаказовРезкаВыбор.Номенклатура,
//|	НоменклатураЗаказовРезкаВыбор.ХарактеристикаНоменклатуры
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	НоменклатураЗаказовРезкаВыбор.Номенклатура КАК Номенклатура,
//|	НоменклатураЗаказовРезкаВыбор.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
//|	НоменклатураЗаказовРезкаВыбор.ЕстьРезка
//|ПОМЕСТИТЬ НоменклатураЗаказовРезка
//|ИЗ
//|	НоменклатураЗаказовРезкаВыбор КАК НоменклатураЗаказовРезкаВыбор
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НоменклатураЗаказовРезкаВыборИтог КАК НоменклатураЗаказовРезкаВыборИтог
//|		ПО НоменклатураЗаказовРезкаВыбор.Номенклатура = НоменклатураЗаказовРезкаВыборИтог.Номенклатура
//|			И НоменклатураЗаказовРезкаВыбор.ХарактеристикаНоменклатуры = НоменклатураЗаказовРезкаВыборИтог.ХарактеристикаНоменклатуры
//|			И НоменклатураЗаказовРезкаВыбор.ПриоритетТЗ = НоменклатураЗаказовРезкаВыборИтог.ПриоритетТЗ
//|
//|ИНДЕКСИРОВАТЬ ПО
//|	Номенклатура
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	БЗ_ОстаткиНаУчасткахОстатки.Номенклатура КАК Номенклатура,
//|	СУММА(ВЫБОР
//|			КОГДА БЗ_ОстаткиНаУчасткахОстатки.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыОстатковНаУчастке.Хранение)
//|					И БЗ_ОстаткиНаУчасткахОстатки.РабочееМесто.ЭтоБуфер = ИСТИНА
//|				ТОГДА БЗ_ОстаткиНаУчасткахОстатки.КоличествоОстаток - БЗ_ОстаткиНаУчасткахОстатки.РезервОстаток
//|			ИНАЧЕ 0
//|		КОНЕЦ) КАК КоличествоБуфер
//|ПОМЕСТИТЬ ОстаткиВБуфере
//|ИЗ
//|	РегистрНакопления.БЗ_ОстаткиНаУчастках.Остатки(
//|			,
//|			Участок.Подразделение = &Подразделение
//|				И Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыОстатковНаУчастке.Хранение)
//|				И РабочееМесто.ЭтоБуфер = ИСТИНА) КАК БЗ_ОстаткиНаУчасткахОстатки
//|
//|СГРУППИРОВАТЬ ПО
//|	БЗ_ОстаткиНаУчасткахОстатки.Номенклатура
//|
//|ИНДЕКСИРОВАТЬ ПО
//|	Номенклатура
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	БЗ_ОперацияРезка_ИзделияОстатки.Номенклатура КАК Номенклатура,
//|	БЗ_ОперацияРезка_ИзделияОстатки.ХарактеристикаНоменклатуры,
//|	БЗ_РасчетРезкиВыходныеИзделия.Количество КАК КоличествоРасчет,
//|	0 КАК КоличествоПодготовлен,
//|	БЗ_РасчетРезкиВыходныеИзделия.ЗаказНаПроизводство
//|ПОМЕСТИТЬ ПланыРезки
//|ИЗ
//|	РегистрНакопления.БЗ_ОперацияРезка_Изделия.Остатки(
//|			,
//|			Участок.Подразделение = &Подразделение
//|				И Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыОстатковНаУчастке.Расчет)) КАК БЗ_ОперацияРезка_ИзделияОстатки
//|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.БЗ_РасчетРезки.ВыходныеИзделия КАК БЗ_РасчетРезкиВыходныеИзделия
//|		ПО БЗ_ОперацияРезка_ИзделияОстатки.КлючИзделия = БЗ_РасчетРезкиВыходныеИзделия.КлючИзделия
//|ГДЕ
//|	БЗ_РасчетРезкиВыходныеИзделия.КлючСхемы = ""                                    ""
//|	И (БЗ_РасчетРезкиВыходныеИзделия.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.Создан)
//|			ИЛИ БЗ_РасчетРезкиВыходныеИзделия.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.ВРасчете))
//|
//|ОБЪЕДИНИТЬ ВСЕ
//|
//|ВЫБРАТЬ
//|	БЗ_ОперацияРезка_ИзделияОстатки.Номенклатура,
//|	БЗ_ОперацияРезка_ИзделияОстатки.ХарактеристикаНоменклатуры,
//|	0,
//|	БЗ_РасчетРезкиВыходныеИзделия.Количество,
//|	БЗ_РасчетРезкиВыходныеИзделия.ЗаказНаПроизводство
//|ИЗ
//|	РегистрНакопления.БЗ_ОперацияРезка_Изделия.Остатки(
//|			,
//|			Участок.Подразделение = &Подразделение
//|				И Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыОстатковНаУчастке.Рассчитан)) КАК БЗ_ОперацияРезка_ИзделияОстатки
//|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.БЗ_РасчетРезки.ВыходныеИзделия КАК БЗ_РасчетРезкиВыходныеИзделия
//|		ПО БЗ_ОперацияРезка_ИзделияОстатки.КлючИзделия = БЗ_РасчетРезкиВыходныеИзделия.КлючИзделия
//|ГДЕ
//|	(БЗ_РасчетРезкиВыходныеИзделия.КлючСхемы <> ""                                    ""
//|			ИЛИ БЗ_РасчетРезкиВыходныеИзделия.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.Рассчитан))
//|
//|ОБЪЕДИНИТЬ ВСЕ
//|
//|ВЫБРАТЬ
//|	БЗ_ОперацияРезка_ИзделияОстатки.Номенклатура,
//|	БЗ_ОперацияРезка_ИзделияОстатки.ХарактеристикаНоменклатуры,
//|	БЗ_РасчетРезкиВыходныеИзделияВРасчете.Количество,
//|	0,
//|	БЗ_РасчетРезкиВыходныеИзделияВРасчете.ЗаказНаПроизводство
//|ИЗ
//|	РегистрНакопления.БЗ_ОперацияРезка_Изделия.Остатки(
//|			,
//|			Участок.Подразделение = &Подразделение
//|				И Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыОстатковНаУчастке.Расчет)) КАК БЗ_ОперацияРезка_ИзделияОстатки
//|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.БЗ_РасчетРезки.ВыходныеИзделияВРасчете КАК БЗ_РасчетРезкиВыходныеИзделияВРасчете
//|		ПО БЗ_ОперацияРезка_ИзделияОстатки.КлючИзделия = БЗ_РасчетРезкиВыходныеИзделияВРасчете.КлючИзделия
//|ГДЕ
//|	БЗ_РасчетРезкиВыходныеИзделияВРасчете.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.Рассчитан)
//|
//|ОБЪЕДИНИТЬ ВСЕ
//|
//|ВЫБРАТЬ
//|	БЗ_ОперацияРезка_ИзделияОстатки.Номенклатура,
//|	БЗ_ОперацияРезка_ИзделияОстатки.ХарактеристикаНоменклатуры,
//|	0,
//|	БЗ_РасчетРезкиВыходныеИзделияИзБуфера.Количество,
//|	БЗ_РасчетРезкиВыходныеИзделияИзБуфера.ЗаказНаПроизводство
//|ИЗ
//|	РегистрНакопления.БЗ_ОперацияРезка_Изделия.Остатки(
//|			,
//|			Участок.Подразделение = &Подразделение
//|				И Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыОстатковНаУчастке.Рассчитан)) КАК БЗ_ОперацияРезка_ИзделияОстатки
//|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.БЗ_РасчетРезки.ВыходныеИзделияИзБуфера КАК БЗ_РасчетРезкиВыходныеИзделияИзБуфера
//|		ПО БЗ_ОперацияРезка_ИзделияОстатки.КлючИзделия = БЗ_РасчетРезкиВыходныеИзделияИзБуфера.КлючИзделия
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	ПланыРезки.Номенклатура КАК Номенклатура,
//|	ПланыРезки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
//|	СУММА(ПланыРезки.КоличествоРасчет) КАК КоличествоРасчет,
//|	СУММА(ПланыРезки.КоличествоПодготовлен) КАК КоличествоПодготовлен,
//|	ПланыРезки.ЗаказНаПроизводство
//|ПОМЕСТИТЬ ПланыРезкиСводно
//|ИЗ
//|	ПланыРезки КАК ПланыРезки
//|
//|СГРУППИРОВАТЬ ПО
//|	ПланыРезки.Номенклатура,
//|	ПланыРезки.ХарактеристикаНоменклатуры,
//|	ПланыРезки.ЗаказНаПроизводство
//|
//|ИНДЕКСИРОВАТЬ ПО
//|	Номенклатура
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	МАКСИМУМ(ЗначенияСвойствОбъектов.Значение) КАК Цвет,
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
//|ПОМЕСТИТЬ НоменклатураЗаказовЦвет
//|ИЗ
//|	ПланВидовХарактеристик.СвойстваОбъектов КАК СвойстваОбъектов,
//|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НоменклатураЗаказов КАК НоменклатураЗаказов
//|		ПО ЗначенияСвойствОбъектов.Объект = НоменклатураЗаказов.ХарактеристикаНоменклатуры
//|ГДЕ
//|	СвойстваОбъектов.НазначениеСвойства = ЗНАЧЕНИЕ(ПланВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ХарактеристикиНоменклатуры)
//|	И СвойстваОбъектов.Наименование = ""Цвет""
//|
//|СГРУППИРОВАТЬ ПО
//|	НоменклатураЗаказов.ХарактеристикаНоменклатуры
//|
//|ИНДЕКСИРОВАТЬ ПО
//|	ХарактеристикаНоменклатуры
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	БЗ_НезавершенноеПроизводство_ИзделияОстатки.КлючИзделия,
//|	МАКСИМУМ(БЗ_НезавершенноеПроизводство_ИзделияОстатки.КоличествоОстаток) КАК КоличествоОстаток,
//|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ЗаказНаПроизводство,
//|	МАКСИМУМ(БЗ_НезавершенноеПроизводство_ИзделияОстатки.Операция) КАК Операция,
//|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Номенклатура,
//|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ХарактеристикаНоменклатуры
//|ПОМЕСТИТЬ ПланПроизводства
//|ИЗ
//|	РегистрНакопления.БЗ_НезавершенноеПроизводство_Изделия.Остатки КАК БЗ_НезавершенноеПроизводство_ИзделияОстатки
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.БЗ_МаршрутныйЛистПроизводства.ВыходныеИзделия КАК БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия
//|		ПО БЗ_НезавершенноеПроизводство_ИзделияОстатки.КлючИзделия = БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.КлючИзделия
//|
//|СГРУППИРОВАТЬ ПО
//|	БЗ_НезавершенноеПроизводство_ИзделияОстатки.КлючИзделия,
//|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ЗаказНаПроизводство,
//|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Номенклатура,
//|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ХарактеристикаНоменклатуры
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	БЗ_ТСД_ТехнологическаяОперация_Положить.КлючПоложить,
//|	БЗ_ТСД_ТехнологическаяОперация_Положить.Количество
//|ПОМЕСТИТЬ БракНедостача
//|ИЗ
//|	РегистрСведений.БЗ_ТСД_ТехнологическаяОперация КАК БЗ_ТСД_ТехнологическаяОперация_Положить
//|ГДЕ
//|	БЗ_ТСД_ТехнологическаяОперация_Положить.ВидДействия = ЗНАЧЕНИЕ(Перечисление.БЗ_ТСД_ВидыДействий.Положить)
//|	И (БЗ_ТСД_ТехнологическаяОперация_Положить.ТипДвиженияТСД = ЗНАЧЕНИЕ(Справочник.БЗ_ТипыДвижений_ТСД.Брак)
//|			ИЛИ БЗ_ТСД_ТехнологическаяОперация_Положить.ТипДвиженияТСД = ЗНАЧЕНИЕ(Справочник.БЗ_ТипыДвижений_ТСД.Недостача))
//|
//|СГРУППИРОВАТЬ ПО
//|	БЗ_ТСД_ТехнологическаяОперация_Положить.КлючПоложить,
//|	БЗ_ТСД_ТехнологическаяОперация_Положить.Количество
//|
//|ОБЪЕДИНИТЬ ВСЕ
//|
//|ВЫБРАТЬ
//|	БЗ_ОстаткиНаУчасткахОстатки.КлючИзделия,
//|	СУММА(БЗ_ОстаткиНаУчасткахОстатки.КоличествоОстаток)
//|ИЗ
//|	РегистрНакопления.БЗ_ОстаткиНаУчастках.Остатки(
//|			,
//|			Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыОСтатковНаУчастке.Брак)
//|				ИЛИ Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыОСтатковНаУчастке.Недостача)) КАК БЗ_ОстаткиНаУчасткахОстатки
//|
//|СГРУППИРОВАТЬ ПО
//|	БЗ_ОстаткиНаУчасткахОстатки.КлючИзделия
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	СУММА(ПланПроизводства.КоличествоОстаток) КАК ВПроизводстве,
//|	ПланПроизводства.ЗаказНаПроизводство,
//|	СУММА(-ЕСТЬNULL(БракНедостача.Количество, 0)) КАК БракНедостача,
//|	ПланПроизводства.Номенклатура КАК Номенклатура,
//|	ПланПроизводства.ХарактеристикаНоменклатуры
//|ПОМЕСТИТЬ НезавершенноеПроизводство
//|ИЗ
//|	ПланПроизводства КАК ПланПроизводства
//|		ЛЕВОЕ СОЕДИНЕНИЕ БракНедостача КАК БракНедостача
//|		ПО ПланПроизводства.КлючИзделия = БракНедостача.КлючПоложить
//|
//|СГРУППИРОВАТЬ ПО
//|	ПланПроизводства.ХарактеристикаНоменклатуры,
//|	ПланПроизводства.Номенклатура,
//|	ПланПроизводства.ЗаказНаПроизводство
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	СУММА(НезавершенноеПроизводство.ВПроизводстве) КАК ВПроизводстве,
//|	НезавершенноеПроизводство.ЗаказНаПроизводство,
//|	НезавершенноеПроизводство.Номенклатура КАК Номенклатура,
//|	НезавершенноеПроизводство.ХарактеристикаНоменклатуры,
//|	СУММА(НезавершенноеПроизводство.БракНедостача) КАК БракНедостача
//|ПОМЕСТИТЬ НезавершенноеПроизводствоСводно
//|ИЗ
//|	НезавершенноеПроизводство КАК НезавершенноеПроизводство
//|
//|СГРУППИРОВАТЬ ПО
//|	НезавершенноеПроизводство.ЗаказНаПроизводство,
//|	НезавершенноеПроизводство.Номенклатура,
//|	НезавершенноеПроизводство.ХарактеристикаНоменклатуры
//|
//|ИНДЕКСИРОВАТЬ ПО
//|	Номенклатура
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	ОчередьЗаказов.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
//|	ОчередьЗаказов.Номенклатура КАК Номенклатура,
//|	ОчередьЗаказов.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
//|	ОчередьЗаказов.НужноПроизвести КАК ПланПроизвести,
//|	ОчередьЗаказов.ЗаказНаПроизводствоДата,
//|	ОчередьЗаказов.НоменклатураНаименование,
//|	ОчередьЗаказов.ХарактеристикаНаименование,
//|	ОчередьЗаказов.Подразделение КАК Подразделение,
//|	ОчередьЗаказов.СкладСборки КАК СкладСборки,
//|	ОчередьЗаказов.Организация КАК Организация,
//|	ОчередьЗаказов.ТипСтроки,
//|	ОчередьЗаказов.Количество,
//|	НоменклатураЗаказовРезка.ЕстьРезка КАК ЕстьРезка,
//|	0 КАК НужноРезать,
//|	0 КАК НужноРазместить,
//|	ВЫБОР
//|		КОГДА НоменклатураЗаказовРезка.ЕстьРезка
//|			ТОГДА ОчередьЗаказов.НужноПроизвести
//|		ИНАЧЕ 0
//|	КОНЕЦ КАК ПланРезать,
//|	ОчередьЗаказов.РазмерX,
//|	ОчередьЗаказов.РазмерY,
//|	ОчередьЗаказов.РазмерZ,
//|	ОчередьЗаказов.Вес,
//|	ОчередьЗаказов.Объем,
//|	ЕСТЬNULL(ОстаткиВБуфере.КоличествоБуфер, 0) КАК ЕстьВБуфере,
//|	ЕСТЬNULL(НоменклатураЗаказовЦвет.Цвет, ""----"") КАК Цвет,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказов.ЭтоРекламация
//|			ТОГДА ""Рекламация""
//|		ИНАЧЕ ВЫБОР
//|				КОГДА ОчередьЗаказов.Инициатор = ЗНАЧЕНИЕ(ДОКУМЕНТ.НП_НедельнаяПартия.ПустаяСсылка)
//|						ИЛИ ОчередьЗаказов.Инициатор = НЕОПРЕДЕЛЕНО
//|					ТОГДА ""БЕЗ НЕДЕЛЬНОЙ ПАРТИИ""
//|				ИНАЧЕ ОчередьЗаказов.Инициатор
//|			КОНЕЦ
//|	КОНЕЦ КАК НедельнаяПартия,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказов.ЭтоРекламация
//|			ТОГДА НАЧАЛОПЕРИОДА(ОчередьЗаказов.ИнициаторДата, НЕДЕЛЯ)
//|		ИНАЧЕ ВЫБОР
//|				КОГДА ОчередьЗаказов.Инициатор = ЗНАЧЕНИЕ(ДОКУМЕНТ.НП_НедельнаяПартия.ПустаяСсылка)
//|						ИЛИ ОчередьЗаказов.Инициатор = НЕОПРЕДЕЛЕНО
//|					ТОГДА НАЧАЛОПЕРИОДА(ОчередьЗаказов.ИнициаторДата, НЕДЕЛЯ)
//|				ИНАЧЕ ВЫБОР
//|						КОГДА НоменклатураЗаказовРезка.Номенклатура.НоменклатурнаяГруппаТорговля <> ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.ПустаяСсылка)
//|							ТОГДА НоменклатураЗаказовРезка.Номенклатура.НоменклатурнаяГруппаТорговля
//|						ИНАЧЕ НоменклатураЗаказовРезка.Номенклатура.НоменклатурнаяГруппаПроизводство
//|					КОНЕЦ
//|			КОНЕЦ
//|	КОНЕЦ КАК Линейка,
//|	ЕСТЬNULL(ПланыРезкиСводно.КоличествоРасчет, 0) КАК КоличествоРасчет,
//|	ЕСТЬNULL(ПланыРезкиСводно.КоличествоПодготовлен, 0) КАК КоличествоПодготовлен,
//|	ВЫБОР
//|		КОГДА НоменклатураЗаказовРезка.ЕстьРезка
//|			ТОГДА ОчередьЗаказов.НужноПроизвести
//|		ИНАЧЕ 0
//|	КОНЕЦ - ЕСТЬNULL(ПланыРезкиСводно.КоличествоРасчет, 0) - ЕСТЬNULL(ПланыРезкиСводно.КоличествоПодготовлен, 0) КАК МожноРезать,
//|	ЕСТЬNULL(НезавершенноеПроизводствоСводно.ВПроизводстве, 0) КАК ВПроизводстве,
//|	ЕСТЬNULL(НезавершенноеПроизводствоСводно.БракНедостача, 0) КАК БракНедостача,
//|	ОчередьЗаказов.ИнициаторДата,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказов.ИнициаторДата = ДАТАВРЕМЯ(1, 1, 1)
//|			ТОГДА НАЧАЛОПЕРИОДА(ОчередьЗаказов.ЗаказНаПроизводство.Дата, НЕДЕЛЯ)
//|		ИНАЧЕ НАЧАЛОПЕРИОДА(ОчередьЗаказов.ИнициаторДата, НЕДЕЛЯ)
//|	КОНЕЦ КАК НеделяДокумента
//|ПОМЕСТИТЬ ОчередьЗаказовСводная
//|ИЗ
//|	НоменклатураЗаказовРезка КАК НоменклатураЗаказовРезка
//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОчередьЗаказов КАК ОчередьЗаказов
//|			ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиВБуфере КАК ОстаткиВБуфере
//|			ПО ОчередьЗаказов.Номенклатура = ОстаткиВБуфере.Номенклатура
//|			ЛЕВОЕ СОЕДИНЕНИЕ НоменклатураЗаказовЦвет КАК НоменклатураЗаказовЦвет
//|			ПО ОчередьЗаказов.ХарактеристикаНоменклатуры = НоменклатураЗаказовЦвет.ХарактеристикаНоменклатуры
//|			ЛЕВОЕ СОЕДИНЕНИЕ ПланыРезкиСводно КАК ПланыРезкиСводно
//|			ПО ОчередьЗаказов.Номенклатура = ПланыРезкиСводно.Номенклатура
//|				И ОчередьЗаказов.ХарактеристикаНоменклатуры = ПланыРезкиСводно.ХарактеристикаНоменклатуры
//|				И ОчередьЗаказов.ЗаказНаПроизводство = ПланыРезкиСводно.ЗаказНаПроизводство
//|			ЛЕВОЕ СОЕДИНЕНИЕ НезавершенноеПроизводствоСводно КАК НезавершенноеПроизводствоСводно
//|			ПО ОчередьЗаказов.Номенклатура = НезавершенноеПроизводствоСводно.Номенклатура
//|				И ОчередьЗаказов.ХарактеристикаНоменклатуры = НезавершенноеПроизводствоСводно.ХарактеристикаНоменклатуры
//|				И ОчередьЗаказов.ЗаказНаПроизводство = НезавершенноеПроизводствоСводно.ЗаказНаПроизводство
//|		ПО НоменклатураЗаказовРезка.Номенклатура = ОчередьЗаказов.Номенклатура
//|			И НоменклатураЗаказовРезка.ХарактеристикаНоменклатуры = ОчередьЗаказов.ХарактеристикаНоменклатуры
//|;
//|
//|////////////////////////////////////////////////////////////////////////////////
//|ВЫБРАТЬ
//|	ОчередьЗаказовСводная.НедельнаяПартия КАК НедельнаяПартия,
//|	ОчередьЗаказовСводная.Линейка КАК Линейка,
//|	ОчередьЗаказовСводная.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
//|	ОчередьЗаказовСводная.Цвет КАК Цвет,
//|	ОчередьЗаказовСводная.Номенклатура КАК Номенклатура,
//|	ОчередьЗаказовСводная.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
//|	ОчередьЗаказовСводная.ПланПроизвести,
//|	ОчередьЗаказовСводная.ЗаказНаПроизводствоДата КАК ЗаказНаПроизводствоДата,
//|	ОчередьЗаказовСводная.НоменклатураНаименование КАК НоменклатураНаименование,
//|	ОчередьЗаказовСводная.ХарактеристикаНаименование КАК ХарактеристикаНаименование,
//|	ОчередьЗаказовСводная.Подразделение КАК Подразделение,
//|	ОчередьЗаказовСводная.СкладСборки КАК СкладСборки,
//|	ОчередьЗаказовСводная.Организация КАК Организация,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказовСводная.ЗаказНаПроизводство ЕСТЬ NULL
//|			ТОГДА ЛОЖЬ
//|		ИНАЧЕ ИСТИНА
//|	КОНЕЦ КАК ЕстьЗаказ,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказовСводная.НедельнаяПартия ЕСТЬ NULL
//|			ТОГДА ЛОЖЬ
//|		ИНАЧЕ ИСТИНА
//|	КОНЕЦ КАК ЕстьНП,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказовСводная.Номенклатура ЕСТЬ NULL
//|			ТОГДА ЛОЖЬ
//|		ИНАЧЕ ИСТИНА
//|	КОНЕЦ КАК ЕстьНоменклатура,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказовСводная.Цвет ЕСТЬ NULL
//|			ТОГДА ЛОЖЬ
//|		ИНАЧЕ ИСТИНА
//|	КОНЕЦ КАК ЕстьЦвет,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказовСводная.Линейка ЕСТЬ NULL
//|			ТОГДА ЛОЖЬ
//|		ИНАЧЕ ИСТИНА
//|	КОНЕЦ КАК ЕстьЛинейка,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказовСводная.ХарактеристикаНоменклатуры ЕСТЬ NULL
//|			ТОГДА ЛОЖЬ
//|		ИНАЧЕ ИСТИНА
//|	КОНЕЦ КАК ЕстьХарактеристика,
//|	ОчередьЗаказовСводная.ТипСтроки,
//|	ВЫБОР
//|		КОГДА НЕ ОчередьЗаказовСводная.Номенклатура ЕСТЬ NULL
//|			ТОГДА ОчередьЗаказовСводная.Номенклатура
//|		ИНАЧЕ ВЫБОР
//|				КОГДА НЕ ОчередьЗаказовСводная.ЗаказНаПроизводство ЕСТЬ NULL
//|					ТОГДА ОчередьЗаказовСводная.ЗаказНаПроизводство
//|				ИНАЧЕ ВЫБОР
//|						КОГДА НЕ ОчередьЗаказовСводная.НедельнаяПартия ЕСТЬ NULL
//|							ТОГДА ОчередьЗаказовСводная.НедельнаяПартия
//|						ИНАЧЕ NULL
//|					КОНЕЦ
//|			КОНЕЦ
//|	КОНЕЦ КАК ПолеДерева1,
//|	ВЫБОР
//|		КОГДА НЕ ОчередьЗаказовСводная.ХарактеристикаНоменклатуры ЕСТЬ NULL
//|			ТОГДА ОчередьЗаказовСводная.ХарактеристикаНоменклатуры
//|		ИНАЧЕ ВЫБОР
//|				КОГДА НЕ ОчередьЗаказовСводная.Цвет ЕСТЬ NULL
//|					ТОГДА ОчередьЗаказовСводная.Цвет
//|				ИНАЧЕ ВЫБОР
//|						КОГДА НЕ ОчередьЗаказовСводная.Линейка ЕСТЬ NULL
//|							ТОГДА ОчередьЗаказовСводная.Линейка
//|						ИНАЧЕ NULL
//|					КОНЕЦ
//|			КОНЕЦ
//|	КОНЕЦ КАК ПолеДерева2,
//|	ОчередьЗаказовСводная.Количество,
//|	ОчередьЗаказовСводная.ЕстьРезка,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказовСводная.ЗаказНаПроизводство.ДокументОснование.РаскладкаПроизведена
//|			ТОГДА 0
//|		ИНАЧЕ ОчередьЗаказовСводная.НужноРезать
//|	КОНЕЦ КАК НужноРезать,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказовСводная.ЗаказНаПроизводство.ДокументОснование.РаскладкаПроизведена
//|			ТОГДА 0
//|		ИНАЧЕ ОчередьЗаказовСводная.НужноРазместить
//|	КОНЕЦ КАК НужноРазместить,
//|	ОчередьЗаказовСводная.ПланРезать КАК ПланРезать,
//|	0 КАК Флаг,
//|	ОчередьЗаказовСводная.РазмерX,
//|	ОчередьЗаказовСводная.РазмерY,
//|	ОчередьЗаказовСводная.РазмерZ,
//|	ОчередьЗаказовСводная.Вес,
//|	ОчередьЗаказовСводная.Объем,
//|	ОчередьЗаказовСводная.РазмерX * ОчередьЗаказовСводная.РазмерY / 1000000 * ОчередьЗаказовСводная.МожноРезать КАК Площадь,
//|	ОчередьЗаказовСводная.ЕстьВБуфере,
//|	0 КАК ИзБуфера,
//|	ОчередьЗаказовСводная.КоличествоРасчет КАК ПланируетсяРасчет,
//|	ОчередьЗаказовСводная.КоличествоПодготовлен КАК ГотовРасчет,
//|	ВЫБОР
//|		КОГДА ОчередьЗаказовСводная.ЗаказНаПроизводство.ДокументОснование.РаскладкаПроизведена
//|			ТОГДА 1
//|		ИНАЧЕ 0
//|	КОНЕЦ КАК РаскладкаПроизведена,
//|	ОчередьЗаказовСводная.ВПроизводстве,
//|	ОчередьЗаказовСводная.БракНедостача,
//|	""                                    "" КАК КлючИзделия,
//|	ОчередьЗаказовСводная.ИнициаторДата КАК ИнициаторДата,
//|	ОчередьЗаказовСводная.НеделяДокумента КАК НеделяДокумента
//|ИЗ
//|	ОчередьЗаказовСводная КАК ОчередьЗаказовСводная
//|
//|УПОРЯДОЧИТЬ ПО
//|	НеделяДокумента,
//|	ЗаказНаПроизводствоДата,
//|	НоменклатураНаименование
//|ИТОГИ
//|	СУММА(НужноРезать),
//|	СУММА(НужноРазместить),
//|	СУММА(ПланРезать),
//|	СУММА(ПланируетсяРасчет),
//|	СУММА(ГотовРасчет)
//|ПО
//|	НедельнаяПартия,
//|	Линейка,
//|	ЗаказНаПроизводство,
//|	Цвет,
//|	Номенклатура";

	
	Запрос.Параметры.Вставить("Подразделение",		 Подразделение);
	Запрос.Параметры.Вставить("ВидПартии",			 ВидПартии);
	Запрос.Параметры.Вставить("вхДатаЗапроса", 		 вхДатаЗапроса);
	

	ТЗОчередьЗаказов = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией); 
	//ВнешниеОбработки.Создать("C:\Users\admin1c\Desktop\!Служебные\запросник2_0.epf").ОтладитьЗапрос(Запрос);;
	Возврат  ТЗОчередьЗаказов;
	
	//Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	//
	//Пока Выборка.Следующий() Цикл
	//	
	//	
	//КонецЦикла;
	//
КонецФункции


Функция ПолучитьТЗДокРР(Отказ) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	БЗ_РасчетРезки.Ссылка КАК ДокументРасчетРезки,
		|	БЗ_РасчетРезки.Статус,
		|	ВЫБОР
		|		КОГДА БЗ_РасчетРезки.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.Создан)
		|			ТОГДА 50
		|		ИНАЧЕ ВЫБОР
		|				КОГДА БЗ_РасчетРезки.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.ВРасчете)
		|					ТОГДА 30
		|				ИНАЧЕ ВЫБОР
		|						КОГДА БЗ_РасчетРезки.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.Рассчитан)
		|							ТОГДА 20
		|						ИНАЧЕ ВЫБОР
		|								КОГДА БЗ_РасчетРезки.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.ВРезке)
		|									ТОГДА 10
		|								ИНАЧЕ 0
		|							КОНЕЦ
		|					КОНЕЦ
		|			КОНЕЦ
		|	КОНЕЦ КАК СтатусПриоритет,
		|	БЗ_РасчетРезки.ДелитьПоЗНПиВидамФрезеровки
		|ПОМЕСТИТЬ СписокДокументовРР
		|ИЗ
		|	Документ.БЗ_РасчетРезки КАК БЗ_РасчетРезки
		|ГДЕ
		|	БЗ_РасчетРезки.Статус <> ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.Отменен)
		|	И БЗ_РасчетРезки.Статус <> ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.Завершен)
		|	И БЗ_РасчетРезки.Проведен = ИСТИНА
		|	И БЗ_РасчетРезки.Статус <> ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	БЗ_РасчетРезки.Ссылка,
		|	БЗ_РасчетРезки.Статус,
		|	ВЫБОР
		|		КОГДА БЗ_РасчетРезки.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.Создан)
		|			ТОГДА 50
		|		ИНАЧЕ ВЫБОР
		|				КОГДА БЗ_РасчетРезки.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.ВРасчете)
		|					ТОГДА 30
		|				ИНАЧЕ ВЫБОР
		|						КОГДА БЗ_РасчетРезки.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.Рассчитан)
		|							ТОГДА 20
		|						ИНАЧЕ ВЫБОР
		|								КОГДА БЗ_РасчетРезки.Статус = ЗНАЧЕНИЕ(Перечисление.БЗ_СтатусыРасчетаРезки.ВРезке)
		|									ТОГДА 10
		|								ИНАЧЕ 0
		|							КОНЕЦ
		|					КОНЕЦ
		|			КОНЕЦ
		|	КОНЕЦ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БЗ_РасчетРезкиСхемаРезкиИзделий.Кратность) КАК Листов,
		|	СУММА(1) КАК Заданий,
		|	БЗ_РасчетРезкиСхемаРезкиИзделий.Ссылка КАК ДокументРасчетРезки
		|ПОМЕСТИТЬ СписокСхем
		|ИЗ
		|	СписокДокументовРР КАК СписокДокументовРР
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.БЗ_РасчетРезки.СхемаРезкиИзделий КАК БЗ_РасчетРезкиСхемаРезкиИзделий
		|		ПО СписокДокументовРР.ДокументРасчетРезки = БЗ_РасчетРезкиСхемаРезкиИзделий.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	БЗ_РасчетРезкиСхемаРезкиИзделий.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БЗ_РасчетРезкиВыходныеИзделия.Количество) КАК Заготовок,
		|	СУММА(1) КАК Позиций,
		|	БЗ_РасчетРезкиВыходныеИзделия.Ссылка КАК ДокументРасчетРезки
		|ПОМЕСТИТЬ СписокВИ
		|ИЗ
		|	СписокДокументовРР КАК СписокДокументовРР
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.БЗ_РасчетРезки.ВыходныеИзделия КАК БЗ_РасчетРезкиВыходныеИзделия
		|		ПО СписокДокументовРР.ДокументРасчетРезки = БЗ_РасчетРезкиВыходныеИзделия.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	БЗ_РасчетРезкиВыходныеИзделия.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БЗ_РасчетРезкиВыходныеИзделияВРасчете.Количество) КАК Заготовок,
		|	СУММА(1) КАК Позиций,
		|	БЗ_РасчетРезкиВыходныеИзделияВРасчете.Ссылка КАК ДокументРасчетРезки
		|ПОМЕСТИТЬ СписокВИВР
		|ИЗ
		|	СписокДокументовРР КАК СписокДокументовРР
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.БЗ_РасчетРезки.ВыходныеИзделияВРасчете КАК БЗ_РасчетРезкиВыходныеИзделияВРасчете
		|		ПО СписокДокументовРР.ДокументРасчетРезки = БЗ_РасчетРезкиВыходныеИзделияВРасчете.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	БЗ_РасчетРезкиВыходныеИзделияВРасчете.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БЗ_РасчетРезкиВыходныеИзделияВБуфер.Количество) КАК Заготовок,
		|	СУММА(1) КАК Позиций,
		|	БЗ_РасчетРезкиВыходныеИзделияВБуфер.Ссылка КАК ДокументРасчетРезки
		|ПОМЕСТИТЬ СписокВИВБ
		|ИЗ
		|	СписокДокументовРР КАК СписокДокументовРР
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.БЗ_РасчетРезки.ВыходныеИзделияВБуфер КАК БЗ_РасчетРезкиВыходныеИзделияВБуфер
		|		ПО СписокДокументовРР.ДокументРасчетРезки = БЗ_РасчетРезкиВыходныеИзделияВБуфер.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	БЗ_РасчетРезкиВыходныеИзделияВБуфер.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БЗ_РасчетРезкиВыходныеИзделияИзБуфера.Количество) КАК Заготовок,
		|	СУММА(1) КАК Позиций,
		|	БЗ_РасчетРезкиВыходныеИзделияИзБуфера.Ссылка КАК ДокументРасчетРезки
		|ПОМЕСТИТЬ СписокВИИБ
		|ИЗ
		|	СписокДокументовРР КАК СписокДокументовРР
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.БЗ_РасчетРезки.ВыходныеИзделияИзБуфера КАК БЗ_РасчетРезкиВыходныеИзделияИзБуфера
		|		ПО СписокДокументовРР.ДокументРасчетРезки = БЗ_РасчетРезкиВыходныеИзделияИзБуфера.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	БЗ_РасчетРезкиВыходныеИзделияИзБуфера.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(СписокСхем.Листов, 0) КАК Листов,
		|	ЕСТЬNULL(СписокСхем.Заданий, 0) КАК Заданий,
		|	ЕСТЬNULL(СписокВИ.Заготовок, 0) + ЕСТЬNULL(СписокВИВР.Заготовок, 0) + ЕСТЬNULL(СписокВИВБ.Заготовок, 0) + ЕСТЬNULL(СписокВИИБ.Заготовок, 0) КАК Заготовок,
		|	ЕСТЬNULL(СписокВИ.Позиций, 0) + ЕСТЬNULL(СписокВИВР.Позиций, 0) + ЕСТЬNULL(СписокВИВБ.Позиций, 0) + ЕСТЬNULL(СписокВИИБ.Позиций, 0) КАК Позиций,
		|	СписокДокументовРР.ДокументРасчетРезки,
		|	СписокДокументовРР.ДокументРасчетРезки.Комментарий КАК Комментарий,
		|	СписокДокументовРР.Статус КАК Статус,
		|	СписокДокументовРР.ДокументРасчетРезки.Дата КАК ДокументРасчетРезкиДата,
		|	СписокДокументовРР.СтатусПриоритет КАК СтатусПриоритет,
		|	ЕСТЬNULL(СписокВИ.Заготовок, 0) + ЕСТЬNULL(СписокВИВБ.Заготовок, 0) КАК ЗаготовокНаЛистах,
		|	ЕСТЬNULL(СписокВИВР.Заготовок, 0) КАК ЗаготовокОсталось,
		|	ЕСТЬNULL(СписокВИВБ.Заготовок, 0) КАК ЗаготовокВБуфер,
		|	ЕСТЬNULL(СписокВИИБ.Заготовок, 0) КАК ЗаготовокИзБуфера,
		|	СписокДокументовРР.ДелитьПоЗНПиВидамФрезеровки
		|ИЗ
		|	СписокДокументовРР КАК СписокДокументовРР
		|		ЛЕВОЕ СОЕДИНЕНИЕ СписокСхем КАК СписокСхем
		|		ПО СписокДокументовРР.ДокументРасчетРезки = СписокСхем.ДокументРасчетРезки
		|		ЛЕВОЕ СОЕДИНЕНИЕ СписокВИ КАК СписокВИ
		|		ПО СписокДокументовРР.ДокументРасчетРезки = СписокВИ.ДокументРасчетРезки
		|		ЛЕВОЕ СОЕДИНЕНИЕ СписокВИВР КАК СписокВИВР
		|		ПО СписокДокументовРР.ДокументРасчетРезки = СписокВИВР.ДокументРасчетРезки
		|		ЛЕВОЕ СОЕДИНЕНИЕ СписокВИВБ КАК СписокВИВБ
		|		ПО СписокДокументовРР.ДокументРасчетРезки = СписокВИВБ.ДокументРасчетРезки
		|		ЛЕВОЕ СОЕДИНЕНИЕ СписокВИИБ КАК СписокВИИБ
		|		ПО СписокДокументовРР.ДокументРасчетРезки = СписокВИИБ.ДокументРасчетРезки
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтатусПриоритет УБЫВ,
		|	ДокументРасчетРезкиДата УБЫВ";
   ТЗДРР = Запрос.Выполнить().Выгрузить();
   Возврат ТЗДРР;
КонецФункции