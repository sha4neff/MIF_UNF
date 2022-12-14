
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоРасчетыСПокупателями = Параметры.ЭтоРасчетыСПокупателями;
	ТипДокумента = Параметры.ТипДокумента;
	СтрокаИслючений = "";
	Параметры.Свойство("СтрокаИслючений", СтрокаИслючений);
	
	Контрагент = Параметры.Отбор.Контрагент;
	
	ОтборПоДоговору = Параметры.Отбор.Свойство("Договор");
	Если ОтборПоДоговору Тогда
		Договор = Параметры.Отбор.Договор;
	Иначе
		Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
	Если ТипДокумента = Тип("ДокументСсылка.ПоступлениеНаСчет")
		ИЛИ ТипДокумента = Тип("ДокументСсылка.ПоступлениеВКассу") Тогда
		
		Если ЭтоРасчетыСПокупателями Тогда
			Список.ТекстЗапроса = ПолучитьТекстЗапросаДокументыРасчетовСПокупателямиПоступление(ОтборПоДоговору);
		Иначе
			Список.ТекстЗапроса = ПолучитьТекстЗапросаДокументыРасчетовСПоставщикамиПоступление(ОтборПоДоговору);
			Список.Параметры.УстановитьЗначениеПараметра("КонтрагентПоУмолчанию", Параметры.Отбор.Контрагент);
		КонецЕсли;
		
	Иначе
		
		Если ЭтоРасчетыСПокупателями Тогда
			Список.ТекстЗапроса = ПолучитьТекстЗапросаДокументыРасчетовСПокупателямиСписание(ОтборПоДоговору, СтрокаИслючений);
		Иначе
			Список.ТекстЗапроса = ПолучитьТекстЗапросаДокументыРасчетовСПоставщикамиСписание(ОтборПоДоговору);
		КонецЕсли;
		
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ДоговорПоУмолчанию", Договор);
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ДанныеДокумента = Новый Структура;
	ДанныеДокумента.Вставить("Документ", ТекущиеДанные.Ссылка);
	ДанныеДокумента.Вставить("Договор", ТекущиеДанные.Договор);
	
	ДанныеДокумента.Вставить("Заказ", Неопределено);
	ДанныеДокумента.Вставить("СчетНаОплату", Неопределено);
	ДанныеДокумента.Вставить("УстановитьЗаказ", Ложь);
	
	УчетРасчетовСКонтрагентами.ПолучитьЗаказИСчетНаОПлатуПоДокументу(ДанныеДокумента, ЭтоРасчетыСПокупателями);
	
	ОповеститьОВыборе(ДанныеДокумента);
	
КонецПроцедуры // СписокВыбор()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура вызывается при нажатии на кнопку "Выбрать".
//
&НаКлиенте
Процедура ВыбратьДокумент(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ДанныеДокумента = Новый Структура;
		ДанныеДокумента.Вставить("Документ", ТекущиеДанные.Ссылка);
		ДанныеДокумента.Вставить("Договор", ТекущиеДанные.Договор);
		
		ДанныеДокумента.Вставить("Заказ", Неопределено);
		ДанныеДокумента.Вставить("СчетНаОплату", Неопределено);
		ДанныеДокумента.Вставить("УстановитьЗаказ", Ложь);
		
		УчетРасчетовСКонтрагентами.ПолучитьЗаказИСчетНаОПлатуПоДокументу(ДанныеДокумента, ЭтоРасчетыСПокупателями);
		
		ОповеститьОВыборе(ДанныеДокумента);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры // ВыбратьДокумент()

// Процедура вызывается при нажатии на кнопку "Открыть документ".
//
&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы <> Неопределено Тогда
		ПоказатьЗначение(Неопределено,СтрокаТаблицы.Ссылка);
	КонецЕсли;
	
КонецПроцедуры // ОткрытьДокумент()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает запрос для выбора документов расчетов с покупателями 
// для документов "Поступление на счет" и "Поступление в кассу".
//
&НаСервереБезКонтекста
Функция ПолучитьТекстЗапросаДокументыРасчетовСПокупателямиПоступление(ОтборПоДоговору)
	
	ТекстЗапроса = "";
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.АктВыполненныхРабот) Тогда
		ТекстЗапроса = "
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Дата КАК Дата,
		|	ДанныеДокумента.Номер КАК Номер,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Контрагент КАК Контрагент,
		|	ДанныеДокумента.Договор КАК Договор,
		|	ДанныеДокумента.СуммаДокумента КАК Сумма,
		|	ДанныеДокумента.ВалютаДокумента КАК Валюта,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка) КАК Тип,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СостояниеДокумента
		|ИЗ
		|	Документ.АктВыполненныхРабот КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЗаказПокупателя) Тогда
		ТекстЗапросаПоЗаказамПокупателей = "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Дата КАК Дата,
		|	ДанныеДокумента.Номер КАК Номер,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Контрагент КАК Контрагент,
		|	ДанныеДокумента.Договор КАК Договор,
		|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента КАК ВалютаДокумента,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(ДанныеДокумента.ВидЗаказа) = ТИП(Справочник.ВидыЗаказовПокупателей)
		|			ТОГДА ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка)
		|		ИНАЧЕ ""Заказ-наряд""
		|	КОНЕЦ КАК Поле1,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Поле2
		|ИЗ
		|	Документ.ЗаказПокупателя КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЗаказНарядов.ПорядокСостояний КАК ВидыЗаказНарядовПорядокСостояний
		|		ПО ДанныеДокумента.ВидЗаказа = ВидыЗаказНарядовПорядокСостояний.Ссылка
		|			И ДанныеДокумента.СостояниеЗаказа = ВидыЗаказНарядовПорядокСостояний.Состояние
		|ГДЕ
		|	ДанныеДокумента.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаряд)
		|	И ВидыЗаказНарядовПорядокСостояний.НомерСтроки >= ВЫРАЗИТЬ(ДанныеДокумента.ВидЗаказа КАК Справочник.ВидыЗаказНарядов).НомерСостоянияВыполнения
		|";
		
		
		ТекстЗапросаПоЗаказамПокупателей = СтрЗаменить(ТекстЗапросаПоЗаказамПокупателей, "Заказ-наряд", НСтр("ru = 'Заказ-наряд'"));
		
		ТекстЗапроса = ТекстЗапроса + ТекстЗапросаПоЗаказамПокупателей;
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.Взаимозачет) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	&ДоговорПоУмолчанию,
		|	ДанныеДокумента.СуммаРасчетов,
		|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка),
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.Взаимозачет КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ОтчетКомиссионера) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ОтчетКомиссионера КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ОтчетОПереработке) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ОтчетОПереработке КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПередачаВА) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ПередачаВА КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.РасходнаяНакладная) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.РасходнаяНакладная КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПриемИПередачаВРемонт) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	Null,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ПриемИПередачаВРемонт КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если Лев(ТекстЗапроса, 10) = "ОБЪЕДИНИТЬ" Тогда
		ТекстЗапроса = Сред(ТекстЗапроса, 14);
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции // ПолучитьТекстЗапросаДокументыРасчетовСПокупателями()

// Получает запрос для выбора документов расчетов с поставщиками 
// для документов "Поступление на счет" и "Поступление в кассу".
//
&НаСервереБезКонтекста
Функция ПолучитьТекстЗапросаДокументыРасчетовСПоставщикамиПоступление(ОтборПоДоговору)
	
	ТекстЗапроса = "";
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.АвансовыйОтчет) Тогда
		ТекстЗапроса = "
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Дата КАК Дата,
		|	ДанныеДокумента.Номер КАК Номер,
		|	ДанныеДокумента.Организация КАК Организация,
		|	&КонтрагентПоУмолчанию КАК Контрагент,
		|	&ДоговорПоУмолчанию КАК Договор,
		|	ДанныеДокумента.СуммаДокумента КАК Сумма,
		|	ДанныеДокумента.ВалютаДокумента КАК Валюта,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка) КАК Тип,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СостояниеДокумента
		|ИЗ
		|	Документ.АвансовыйОтчет КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ДополнительныеРасходы) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ДополнительныеРасходы КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.Взаимозачет) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	&ДоговорПоУмолчанию,
		|	ДанныеДокумента.СуммаРасчетов,
		|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка),
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.Взаимозачет КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ОтчетКомитенту) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР КОГДА ДанныеДокумента.Проведен ТОГДА
		|		1
		|	КОГДА ДанныеДокумента.ПометкаУдаления ТОГДА
		|		2
		|	ИНАЧЕ
		|		0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ОтчетКомитенту КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ОтчетПереработчика) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.Сумма,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР КОГДА ДанныеДокумента.Проведен ТОГДА
		|		1
		|	КОГДА ДанныеДокумента.ПометкаУдаления ТОГДА
		|		2
		|	ИНАЧЕ
		|		0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ОтчетПереработчика КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПриходнаяНакладная) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ПриходнаяНакладная КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.РасходнаяНакладная) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	РасходнаяНакладная.Ссылка,
		|	РасходнаяНакладная.Дата,
		|	РасходнаяНакладная.Номер,
		|	РасходнаяНакладная.Организация,
		|	РасходнаяНакладная.Контрагент,
		|	РасходнаяНакладная.Договор,
		|	РасходнаяНакладная.СуммаДокумента,
		|	РасходнаяНакладная.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(РасходнаяНакладная.Ссылка),
		|	ВЫБОР
		|		КОГДА РасходнаяНакладная.Проведен
		|			ТОГДА 1
		|		КОГДА РасходнаяНакладная.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.РасходнаяНакладная КАК РасходнаяНакладная
		|ГДЕ
		|	(РасходнаяНакладная.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратПоставщику)
		|			ИЛИ РасходнаяНакладная.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратКомитенту)
		|			ИЛИ РасходнаяНакладная.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратИзПереработки)
		|			ИЛИ РасходнаяНакладная.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратСОтветхранения))
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.РасходИзКассы) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	&ДоговорПоУмолчанию,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДенежныхСредств,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.РасходИзКассы КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.РасходСоСчета) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	&ДоговорПоУмолчанию,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДенежныхСредств,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.РасходСоСчета КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если Лев(ТекстЗапроса, 10) = "ОБЪЕДИНИТЬ" Тогда
		ТекстЗапроса = Сред(ТекстЗапроса, 14);
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции // ПолучитьТекстЗапросаДокументыРасчетовСПоставщиками()

// Получает запрос для выбора документов расчетов с покупателями 
// для документов "Расход со счета" и "Расход из кассы".
//
&НаСервереБезКонтекста
Функция ПолучитьТекстЗапросаДокументыРасчетовСПокупателямиСписание(ОтборПоДоговору, СтрокаИслючений)
	
	ТекстЗапроса = "";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НЕОПРЕДЕЛЕНО КАК Ссылка,
	|	НЕОПРЕДЕЛЕНО КАК Дата,
	|	НЕОПРЕДЕЛЕНО КАК Номер,
	|	НЕОПРЕДЕЛЕНО КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК Сумма,
	|	НЕОПРЕДЕЛЕНО КАК Валюта,
	|	НЕОПРЕДЕЛЕНО КАК Тип,
	|	НЕОПРЕДЕЛЕНО КАК СостояниеДокумента
	|ГДЕ
	|	ЛОЖЬ
	|";
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПоступлениеВКассу) И СтрНайти(СтрокаИслючений, "ПоступлениеВКассу") = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Дата КАК Дата,
		|	ДанныеДокумента.Номер КАК Номер,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Контрагент КАК Контрагент,
		|	&ДоговорПоУмолчанию КАК Договор,
		|	ДанныеДокумента.СуммаДокумента КАК Сумма,
		|	ДанныеДокумента.ВалютаДенежныхСредств КАК Валюта,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка) КАК Тип,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СостояниеДокумента
		|ИЗ
		|	Документ.ПоступлениеВКассу КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПоступлениеНаСчет) И СтрНайти(СтрокаИслючений, "ПоступлениеНаСчет") = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	&ДоговорПоУмолчанию КАК Договор,
		|	ДанныеДокумента.СуммаДокумента КАК Сумма,
		|	ДанныеДокумента.ВалютаДенежныхСредств,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ПоступлениеНаСчет КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.АктВыполненныхРабот) И СтрНайти(СтрокаИслючений, "АктВыполненныхРабот") = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента КАК Сумма,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.АктВыполненныхРабот КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.Взаимозачет) И СтрНайти(СтрокаИслючений, "Взаимозачет") = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	&ДоговорПоУмолчанию КАК Договор,
		|	ДанныеДокумента.СуммаРасчетов КАК Сумма,
		|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка),
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.Взаимозачет КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЗаказПокупателя) И СтрНайти(СтрокаИслючений, "ЗаказПокупателя") = 0 Тогда
		ТекстЗапросаПоЗаказамПокупателей = "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Дата КАК Дата,
		|	ДанныеДокумента.Номер КАК Номер,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Контрагент КАК Контрагент,
		|	ДанныеДокумента.Договор КАК Договор,
		|	ДанныеДокумента.СуммаДокумента КАК Сумма,
		|	ДанныеДокумента.ВалютаДокумента КАК ВалютаДокумента,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(ДанныеДокумента.ВидЗаказа) = ТИП(Справочник.ВидыЗаказовПокупателей)
		|			ТОГДА ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка)
		|		ИНАЧЕ ""Заказ-наряд""
		|	КОНЕЦ КАК Поле1,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Поле2
		|ИЗ
		|	Документ.ЗаказПокупателя КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаряд)
		|";
		
		ТекстЗапросаПоЗаказамПокупателей = СтрЗаменить(ТекстЗапросаПоЗаказамПокупателей, "Заказ-наряд", НСтр("ru = 'Заказ-наряд'"));
		
		ТекстЗапроса = ТекстЗапроса + ТекстЗапросаПоЗаказамПокупателей;
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ОтчетКомиссионера) И СтрНайти(СтрокаИслючений, "ОтчетКомиссионера") = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента КАК Сумма,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ОтчетКомиссионера КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ОтчетОПереработке) И СтрНайти(СтрокаИслючений, "ОтчетОПереработке") = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ОтчетОПереработке КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПередачаВА) И СтрНайти(СтрокаИслючений, "ПередачаВА") = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ПередачаВА КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПриходнаяНакладная) И СтрНайти(СтрокаИслючений, "ПриходнаяНакладная") = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ПриходнаяНакладная.Ссылка,
		|	ПриходнаяНакладная.Дата,
		|	ПриходнаяНакладная.Номер,
		|	ПриходнаяНакладная.Организация,
		|	ПриходнаяНакладная.Контрагент,
		|	ПриходнаяНакладная.Договор,
		|	ПриходнаяНакладная.СуммаДокумента,
		|	ПриходнаяНакладная.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ПриходнаяНакладная.Ссылка) КАК Поле1,
		|	ВЫБОР
		|		КОГДА ПриходнаяНакладная.Проведен
		|			ТОГДА 1
		|		КОГДА ПриходнаяНакладная.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Поле2
		|ИЗ
		|	Документ.ПриходнаяНакладная КАК ПриходнаяНакладная
		|ГДЕ
		|	(ПриходнаяНакладная.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя)
		|			ИЛИ ПриходнаяНакладная.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтКомиссионера)
		|			ИЛИ ПриходнаяНакладная.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПереработчика)
		|			ИЛИ ПриходнаяНакладная.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратСОтветхранения))
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.РасходнаяНакладная) И СтрНайти(СтрокаИслючений, "РасходнаяНакладная") = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.РасходнаяНакладная КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	// ЧекиККМ
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЧекККМ) И СтрНайти(СтрокаИслючений, "ЧекККМ") = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Дата КАК Дата,
		|	ДанныеДокумента.Номер КАК Номер,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Контрагент КАК Контрагент,
		|	ДанныеДокумента.Договор КАК Договор,
		|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента КАК ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка) КАК Поле1,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|				И ДанныеДокумента.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Поле2
		|ИЗ
		|	Документ.ЧекККМ КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.ОперацияСДенежнымиСредствами
		|";
		
	КонецЕсли;
	// Конец ЧекиККМ
	
	// Эквайринг
	Если ПравоДоступа("Чтение", Метаданные.Документы.ОперацияПоПлатежнымКартам) И СтрНайти(СтрокаИслючений, "ОперацияПоПлатежнымКартам") = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	&ДоговорПоУмолчанию КАК Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДенежныхСредств,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка) КАК Поле1,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Поле2
		|ИЗ
		|	Документ.ОперацияПоПлатежнымКартам КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЭквайринга.ПоступлениеОплатыОтПокупателя)";
		
	КонецЕсли;
	// Конец Эквайринг
	
	Если Лев(ТекстЗапроса, 10) = "ОБЪЕДИНИТЬ" Тогда
		ТекстЗапроса = Сред(ТекстЗапроса, 15);
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Получает запрос для выбора документов расчетов с поставщиками 
// для документов "Расход со счета" и "Расход из кассы".
//
&НаСервереБезКонтекста
Функция ПолучитьТекстЗапросаДокументыРасчетовСПоставщикамиСписание(ОтборПоДоговору)
	
	ТекстЗапроса = "";
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ДополнительныеРасходы) Тогда
		ТекстЗапроса = "
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Дата КАК Дата,
		|	ДанныеДокумента.Номер КАК Номер,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Контрагент КАК Контрагент,
		|	ДанныеДокумента.Договор КАК Договор,
		|	ДанныеДокумента.СуммаДокумента КАК Сумма,
		|	ДанныеДокумента.ВалютаДокумента КАК Валюта,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка) КАК Тип,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СостояниеДокумента
		|ИЗ
		|	Документ.ДополнительныеРасходы КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПриходнаяНакладная) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ПриходнаяНакладная КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.РасходнаяНакладная) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.РасходнаяНакладная КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ОтчетКомитенту) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.СуммаДокумента,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР КОГДА ДанныеДокумента.Проведен ТОГДА
		|		1
		|	КОГДА ДанныеДокумента.ПометкаУдаления ТОГДА
		|		2
		|	ИНАЧЕ
		|		0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ОтчетКомитенту КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ОтчетПереработчика) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.Договор,
		|	ДанныеДокумента.Сумма,
		|	ДанныеДокумента.ВалютаДокумента,
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР КОГДА ДанныеДокумента.Проведен ТОГДА
		|		1
		|	КОГДА ДанныеДокумента.ПометкаУдаления ТОГДА
		|		2
		|	ИНАЧЕ
		|		0
		|	КОНЕЦ
		|ИЗ
		|	Документ.ОтчетПереработчика КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.Взаимозачет) Тогда
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" +
		"
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Контрагент,
		|	&ДоговорПоУмолчанию,
		|	ДанныеДокумента.СуммаРасчетов,
		|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка),
		|	ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка),
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Проведен
		|			ТОГДА 1
		|		КОГДА ДанныеДокумента.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	Документ.Взаимозачет КАК ДанныеДокумента
		|";
		
	КонецЕсли;
	
	Если Лев(ТекстЗапроса, 10) = "ОБЪЕДИНИТЬ" Тогда
		ТекстЗапроса = Сред(ТекстЗапроса, 14);
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти
