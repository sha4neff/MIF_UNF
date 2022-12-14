#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	// Взаиморасчеты
	СоответствиеТабличныхЧастейИРеквизитаЗаказ = Новый Соответствие;
	СоответствиеТабличныхЧастейИРеквизитаЗаказ.Вставить("Запасы", "Заказ");
	РасчетыПроведениеДокументов.ИнициализироватьДополнительныеСвойстваДляПроведения(ЭтотОбъект, ДополнительныеСвойства,
		Отказ, Истина, СоответствиеТабличныхЧастейИРеквизитаЗаказ);
	// Конец Взаиморасчеты
	
	// Инициализация данных документа.
	Документы.ПередачаТоваровМеждуОрганизациями.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Взаиморасчеты
	// Проверим, можно ли продолжать и не было ли отказа в процедурах
	// формирования движений по взаиморасчетам.
	Отказ = ДополнительныеСвойства.Отказ;
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	// Конец Взаиморасчеты
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыВРазрезеГТД(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗакупки(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыКассовыйМетод(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыНераспределенные(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыОтложенные(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРасчетыСПокупателями(ДополнительныеСвойства, Движения, Отказ);
	
	// СерийныеНомера
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераГарантии(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераОстатки(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераКРасходу(ДополнительныеСвойства, Движения, Отказ);
	
	УправлениеНебольшойФирмойСервер.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	//УправлениеНебольшойФирмойСервер.ОтразитьЗакупкиДляКУДиР(ДополнительныеСвойства, Движения, Отказ);
	// Суммы документов для регламентированного учета
	УправлениеНебольшойФирмойСервер.ОтразитьСуммыДокументовРегламентированныйУчет(ДополнительныеСвойства, Движения, Отказ);
	
	// Взаиморасчеты
	УправлениеНебольшойФирмойСервер.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ, "ОплатаДокументов");
	// Конец Взаиморасчеты
	
	
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	Если ДополнительныеСвойства.Свойство("ТаблицаДокументовДляИзменения")
		И ДополнительныеСвойства.ТаблицаДокументовДляИзменения.Количество() > 0
		Тогда
		РасчетыПроведениеДокументов.ОбработатьТаблицуДокументовДляИзмененияПриОтгрузке(ДополнительныеСвойства, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Контроль возникновения отрицательного остатка.
	Документы.ПередачаТоваровМеждуОрганизациями.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = Запасы.Итог("Всего") ;
	
	
	// Положение склада
	Если ПоложениеСклада<>Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
		Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
			СтрокаТабличнойЧасти.СтруктурнаяЕдиница = СтруктурнаяЕдиница;
			СтрокаТабличнойЧасти.Ячейка = Ячейка;
		КонецЦикла;
	Иначе
		СтруктураПолей = ЗаполнениеОбъектовУНФ.СтруктурнаяЕдиницаИЯчейкаДляШапки(Запасы);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураПолей);
	КонецЕсли;
	
	// МобильноеПриложение
	Если МобильноеПриложениеВызовСервера.НужноОграничитьФункциональность()
		И НЕ ПометкаУдаления Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	КонецЕсли;
	// Конец МобильноеПриложение
	
	// ИнтеграцияГИСМ
	ЕстьМаркируемаяПродукцияГИСМ = ИнтеграцияГИСМУНФ.ЕстьМаркируемаяПродукцияГИСМ(Запасы);
	// Конец ИнтеграцияГИСМ
	
	// Интеграция ВЕТИС
	ЕстьПодконтрольнаяПродукцияВЕТИС = ИнтеграцияВЕТИСУНФ.ЕстьПодконтрольнаяПродукцияВЕТИС(Запасы);
	// Конец ИнтеграцияВЕТИС
	
	РасчетыПроведениеДокументов.ПередЗаписьюНакладной(ЭтотОбъект);
	
	// До включения автоматических скидок будем считать, что скидки рассчитаны.
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки") Тогда
		СкидкиРассчитаны = Истина;
	КонецЕсли;
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("Подразделение");
	
	ТаблицаПредоплата = Предоплата.Выгрузить(, "Заказ, СуммаПлатежа");
	ТаблицаПредоплата.Свернуть("Заказ", "СуммаПлатежа");
	
	ПроверитьЗаполненностьСтруктурнойЕдиницы(Отказ, ПроверяемыеРеквизиты);
	
	РасчетыРаботаСФормамиВызовСервера.ПроверитьЗаполнениеДокументаПредоплаты(КонтрагентПолучатель, ПроверяемыеРеквизиты);
	
	// Серийные номера
	РаботаССерийнымиНомерами.ПроверкаЗаполненияСерийныхНомеров(Отказ, Запасы, СерийныеНомера, СтруктурнаяЕдиница, ЭтотОбъект);
	
	// Биллинг
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБиллинг")
		И Договор.ЭтоДоговорОбслуживания Тогда
		
		Для Каждого Стр Из Запасы Цикл
			Если НЕ УправлениеНебольшойФирмойСервер.РазрешенаПродажаНоменклатурыПоДоговоруОбслуживания(Договор, Стр.Номенклатура, Стр.Характеристика) Тогда
				ОбщегоНазначения.СообщитьПользователю(
					НСтр("ru = 'Запрещено проводить незапланированные товары/услуги по текущему договору обслуживания!'"),
					Договор.ДоговорОбслуживанияТарифныйПлан,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Запасы", Стр.НомерСтроки, "Номенклатура"),,
					Отказ
				);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Наборы
	НаборыСервер.ПроверитьТабличнуюЧасть(ЭтотОбъект, "Запасы", Отказ);
	// КонецНаборы
	
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ, Истина);
	
	ГрузовыеТаможенныеДекларацииСервер.ПриОбработкеПроверкиЗаполнения(Отказ, ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
		// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	// Взаиморасчеты
	СоответствиеТабличныхЧастейИРеквизитаЗаказ = Новый Соответствие;
	СоответствиеТабличныхЧастейИРеквизитаЗаказ.Вставить("Запасы", "Заказ");
	РасчетыПроведениеДокументов.ИнициализироватьДополнительныеСвойстваДляПроведения(ЭтотОбъект, ДополнительныеСвойства, Отказ, Ложь, СоответствиеТабличныхЧастейИРеквизитаЗаказ);
	// Конец Взаиморасчеты
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	Если ДополнительныеСвойства.Свойство("ТаблицаДокументовДляИзменения")
		И ДополнительныеСвойства.ТаблицаДокументовДляИзменения.Количество() > 0
		Тогда
		РасчетыПроведениеДокументов.ОбработатьТаблицуДокументовДляИзмененияПриОтгрузке(ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
	
	// Подчиненная счет-фактура
	Если НЕ Отказ Тогда
		
		КонтрольПодчиненнойСчетФактуры();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыЗаполненияДокумента

// Процедура заполняет авансы.
//
Процедура ЗаполнитьПредоплату() Экспорт
	
	Предоплата.Очистить();
	
	ОстатокРасчетов = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
		Запасы.Итог("Всего"),
		?(Договор.ВалютаРасчетов = ВалютаДокумента, Курс, 1),
		Курс,
		?(Договор.ВалютаРасчетов = ВалютаДокумента, Кратность, 1),
		Кратность
		);	
	
	Запрос = НовыйЗапросРасшифровкиПредоплаты();
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
		
		Если ОстатокРасчетов = 0 Тогда
			Прервать;
		КонецЕсли;
		
		Если ВыборкаРезультатаЗапроса.СуммаРасчетов <= ОстатокРасчетов Тогда // сумма остатка меньше или равна чем осталось распределить
			
			НоваяСтрока = Предоплата.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
			ОстатокРасчетов = ОстатокРасчетов - ВыборкаРезультатаЗапроса.СуммаРасчетов;
			
		Иначе // сумма остатка больше чем нужно распределить
			
			НоваяСтрока = Предоплата.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
			НоваяСтрока.СуммаРасчетов = ОстатокРасчетов;
			НоваяСтрока.СуммаПлатежа = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
				НоваяСтрока.СуммаРасчетов,
				ВыборкаРезультатаЗапроса.Курс,
				ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКурс,
				ВыборкаРезультатаЗапроса.Кратность,
				ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКратность
			);
			ОстатокРасчетов = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
	
Функция НовыйЗапросРасшифровкиПредоплаты()
	
	Результат = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|	РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПокупателямиОстатки.Договор.ВалютаРасчетов КАК ВалютаРасчетов,
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаОстаток) КАК СуммаОстаток,
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаВалОстаток) КАК СуммаВалОстаток,
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаРегОстаток) КАК СуммаРегОстаток
	|ПОМЕСТИТЬ ВременнаяТаблицаРасчетыСПокупателямиОстатки
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПокупателямиОстатки.Договор КАК Договор,
	|		РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|		РасчетыСПокупателямиОстатки.Документ.Дата КАК ДокументДата,
	|		РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаРегОстаток, 0) КАК СуммаРегОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПокупателями.Остатки(
	|				,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					И Договор = &Договор
	|					И Заказ В (&Заказ)
	|					И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПокупателямиОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаРасчетыСПокупателями.Договор,
	|		ДвиженияДокументаРасчетыСПокупателями.Документ,
	|		ДвиженияДокументаРасчетыСПокупателями.Документ.Дата,
	|		ДвиженияДокументаРасчетыСПокупателями.Заказ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПокупателями.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.Сумма, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.Сумма, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПокупателями.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаВал, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаВал, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПокупателями.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаРег, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаРег, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПокупателями КАК ДвиженияДокументаРасчетыСПокупателями
	|	ГДЕ
	|		ДвиженияДокументаРасчетыСПокупателями.Регистратор = &Ссылка
	|		И ДвиженияДокументаРасчетыСПокупателями.Период <= &Период
	|		И ДвиженияДокументаРасчетыСПокупателями.Организация = &Организация
	|		И ДвиженияДокументаРасчетыСПокупателями.Контрагент = &Контрагент
	|		И ДвиженияДокументаРасчетыСПокупателями.Договор = &Договор
	|		И ДвиженияДокументаРасчетыСПокупателями.Заказ В(&Заказ)
	|		И ДвиженияДокументаРасчетыСПокупателями.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПокупателямиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПокупателямиОстатки.Документ,
	|	РасчетыСПокупателямиОстатки.Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата,
	|	РасчетыСПокупателямиОстатки.Договор.ВалютаРасчетов
	|
	|ИМЕЮЩИЕ
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаВалОстаток) < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|	РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПокупателямиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаУчета) КАК СуммаУчета,
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаРасчетов) КАК СуммаРасчетов,
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаПлатежа) КАК СуммаПлатежа,
	|	СУММА(ВЫБОР
	|			КОГДА ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаРег, 0) = 0
	|				ТОГДА РасчетыСПокупателямиОстатки.СуммаУчета / ВЫБОР
	|						КОГДА ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаРасчетов, 0) <> 0
	|							ТОГДА РасчетыСПокупателямиОстатки.СуммаРасчетов
	|						ИНАЧЕ 1
	|					КОНЕЦ * (РасчетыСПокупателямиОстатки.КурсыВалютыУчетаКурс / РасчетыСПокупателямиОстатки.КурсыВалютыУчетаКратность)
	|			ИНАЧЕ РасчетыСПокупателямиОстатки.СуммаРег / ВЫБОР
	|					КОГДА ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаРасчетов, 0) <> 0
	|						ТОГДА РасчетыСПокупателямиОстатки.СуммаРасчетов
	|					ИНАЧЕ 1
	|				КОНЕЦ
	|		КОНЕЦ) КАК Курс,
	|	1 КАК Кратность,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКурс КАК КурсыВалютыДокументаКурс,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКратность КАК КурсыВалютыДокументаКратность
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПокупателямиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|		РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|		РасчетыСПокупателямиОстатки.ДокументДата КАК ДокументДата,
	|		РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаОстаток, 0) КАК СуммаУчета,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаВалОстаток, 0) КАК СуммаРасчетов,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаОстаток, 0) * КурсыВалютыУчета.Курс * &КратностьВалютыДокумента / (&КурсВалютыДокумента * КурсыВалютыУчета.Кратность) КАК СуммаПлатежа,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаРегОстаток, 0) КАК СуммаРег,
	|		КурсыВалютыУчета.Курс КАК КурсыВалютыУчетаКурс,
	|		КурсыВалютыУчета.Кратность КАК КурсыВалютыУчетаКратность,
	|		&КурсВалютыДокумента КАК КурсыВалютыДокументаКурс,
	|		&КратностьВалютыДокумента КАК КурсыВалютыДокументаКратность
	|	ИЗ
	|		ВременнаяТаблицаРасчетыСПокупателямиОстатки КАК РасчетыСПокупателямиОстатки
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаУчета) КАК КурсыВалютыУчета
	|			ПО (ИСТИНА)) КАК РасчетыСПокупателямиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПокупателямиОстатки.Документ,
	|	РасчетыСПокупателямиОстатки.Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата,
	|	РасчетыСПокупателямиОстатки.ВалютаРасчетов,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыУчетаКурс,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыУчетаКратность,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКурс,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКратность
	|
	|ИМЕЮЩИЕ
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаРасчетов) > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументДата");
	
	Результат.УстановитьПараметр("Заказ", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Документы.ЗаказПокупателя.ПустаяСсылка()));
	Результат.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	Результат.УстановитьПараметр("Контрагент", КонтрагентПолучатель);
	Результат.УстановитьПараметр("Договор", Договор);
	Результат.УстановитьПараметр("Период", Дата);
	Результат.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	Результат.УстановитьПараметр("ВалютаУчета", Константы.ВалютаУчета.Получить());
	Если Договор.ВалютаРасчетов = ВалютаДокумента Тогда
		Результат.УстановитьПараметр("КурсВалютыДокумента", Курс);
		Результат.УстановитьПараметр("КратностьВалютыДокумента", Кратность);
	Иначе
		Результат.УстановитьПараметр("КурсВалютыДокумента", 1);
		Результат.УстановитьПараметр("КратностьВалютыДокумента", 1);
	КонецЕсли;
	Результат.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

// Процедура отмены проведения у подченненой счет фактуры
//
Процедура КонтрольПодчиненнойСчетФактуры()
	
	СтруктураСчетаФактуры = УправлениеНебольшойФирмойСервер.ПолучитьПодчиненныйСчетФактуру(Ссылка);
	Если СтруктураСчетаФактуры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СчетФактура	 = СтруктураСчетаФактуры.Ссылка;
	Если Не СчетФактура.Проведен Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеТекущегоДокумента = СтрШаблон(НСтр("ru = 'Расходная накладная № %1 от %2'"), Номер, Формат(Дата, "ДЛФ=D"));
	ПредставлениеСчетФактуры = СтрШаблон(НСтр("ru = 'Счет фактура (выданная) № %1 от %2'"), СтруктураСчетаФактуры.Номер, СтруктураСчетаФактуры.Дата);
	ТекстСообщения = СтрШаблон(
		НСтр("ru = 'В связи с отсутствием движений у документа %1 распроводится %2.'"),
		ПредставлениеТекущегоДокумента,
		ПредставлениеСчетФактуры);
	
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	
	СчетФактураОбъект = СчетФактура.ПолучитьОбъект();
	СчетФактураОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	
КонецПроцедуры //КонтрольПодчиненнойСчетФактуры()

Процедура ПроверитьЗаполненностьСтруктурнойЕдиницы(Отказ, ПроверяемыеРеквизиты)
	
	Если ПоложениеСклада <> Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
		ПроверяемыеРеквизиты.Добавить("СтруктурнаяЕдиница");
		Возврат;
	КонецЕсли;
		
	Для Каждого ТекСтрокаТЧ Из Запасы Цикл
		Если Не ТекСтрокаТЧ.ТипНоменклатурыЗапас Тогда
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекСтрокаТЧ.СтруктурнаяЕдиница) Тогда
			Продолжить;
		КонецЕсли;
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
		ЭтотОбъект,
		СтрШаблон(НСтр("ru = 'Не заполнена колонка ""Склад""  в строке %1 списка ""Запасы""'"), ТекСтрокаТЧ.НомерСтроки),
		"Запасы",
		ТекСтрокаТЧ.НомерСтроки,
		"СтруктурнаяЕдиница",
		Отказ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	УправлениеНебольшойФирмойЭлектронныеДокументыСервер.ОчиститьДатуНомерВходящегоДокумента(ЭтотОбъект);
	Предоплата.Очистить();
	
	СпособПродажиГИСМ = "";
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	УправлениеНебольшойФирмойСервер.ПриЗаписиДокументаОснованияСчетаФактуры(Ссылка, ДополнительныеСвойства, Ложь);
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли