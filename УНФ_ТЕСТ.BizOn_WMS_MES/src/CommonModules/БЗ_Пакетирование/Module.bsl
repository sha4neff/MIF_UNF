Функция ПолучитьУпаковкиПродукции(Ссылка) Экспорт
	Если ЗначениеЗАполнено(ссылка.БЗ_ГлавныйЗаказ) Тогда
		  ГлавныйЗаказ=ссылка.БЗ_ГлавныйЗаказ;
	Иначе
		  ГлавныйЗаказ=ссылка;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
"ВЫБРАТЬ
|	ЗаказПокупателяЗапасы.Номенклатура КАК Номенклатура,
|	ЗаказПокупателяЗапасы.Характеристика КАК Характеристика,
|	ЗаказПокупателяЗапасы.Количество КАК Количество,
|	&Рекл КАК Рекламация
|ПОМЕСТИТЬ ВТРекламационныеТовары
|ИЗ
|	Документ.ЗаказПокупателя.Запасы КАК ЗаказПокупателяЗапасы
|ГДЕ
|	(ЗаказПокупателяЗапасы.Ссылка = &ГлавныйЗаказ
|			ИЛИ ЗаказПокупателяЗапасы.Ссылка.БЗ_ГлавныйЗаказ = &ГлавныйЗаказ)
|	И (ЗаказПокупателяЗапасы.Номенклатура В ИЕРАРХИИ (&Материалы)
|			ИЛИ ЗаказПокупателяЗапасы.Номенклатура В ИЕРАРХИИ (&Полуфабрикаты))
|	И ЗаказПокупателяЗапасы.Ссылка.ВидЗаказа.Наименование = ""Рекламация""
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ЕСТЬNULL(ВТРекламационныеТовары.Рекламация, ЗаказПокупателяЗапасы.Номенклатура) КАК Номенклатура,
|	ЗаказПокупателяЗапасы.Характеристика КАК Характеристика,
|	ЗаказПокупателяЗапасы.Количество КАК Количество
|ПОМЕСТИТЬ ВтЗапасы
|ИЗ
|	Документ.ЗаказПокупателя.Запасы КАК ЗаказПокупателяЗапасы
|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРекламационныеТовары КАК ВТРекламационныеТовары
|		ПО (ЗаказПокупателяЗапасы.Номенклатура = ВТРекламационныеТовары.Номенклатура)
|			И (ЗаказПокупателяЗапасы.Характеристика = ВТРекламационныеТовары.Характеристика)
|ГДЕ
|	(ЗаказПокупателяЗапасы.Ссылка = &ГлавныйЗаказ
|			ИЛИ ЗаказПокупателяЗапасы.Ссылка.БЗ_ГлавныйЗаказ = &ГлавныйЗаказ)
|	И ЗаказПокупателяЗапасы.Ссылка.СостояниеЗаказа.Наименование = ""В наборке""
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ РАЗЛИЧНЫЕ
|	СпецификацииПоУмолчанию.Номенклатура КАК Номенклатура,
|	СпецификацииПоУмолчанию.Характеристика КАК Характеристика,
|	СпецификацииПоУмолчанию.Спецификация КАК Спецификация,
|	СУММА(ВтЗапасы.Количество) КАК Количество
|ПОМЕСТИТЬ ВтСпецификацииПоУмолчанию
|ИЗ
|	ВтЗапасы КАК ВтЗапасы
|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СпецификацииПоУмолчанию КАК СпецификацииПоУмолчанию
|		ПО ВтЗапасы.Номенклатура = СпецификацииПоУмолчанию.Номенклатура
|			И ВтЗапасы.Характеристика = СпецификацииПоУмолчанию.Характеристика
|ГДЕ
|	ВтЗапасы.Номенклатура.Изготовитель = &Основное
|
|СГРУППИРОВАТЬ ПО
|	СпецификацииПоУмолчанию.Характеристика,
|	СпецификацииПоУмолчанию.Спецификация,
|	СпецификацииПоУмолчанию.Номенклатура
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ЗаказПокупателяДополнительныеРеквизиты.Значение КАК Значение
|ПОМЕСТИТЬ ВТБезСтолешниц
|ИЗ
|	Документ.ЗаказПокупателя.ДополнительныеРеквизиты КАК ЗаказПокупателяДополнительныеРеквизиты
|ГДЕ
|	ЗаказПокупателяДополнительныеРеквизиты.Свойство.Имя = ""МИФ_БезСтолешниц""
|	И ЗаказПокупателяДополнительныеРеквизиты.Ссылка = &ГлавныйЗаказ
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ВтСпецификацииПоУмолчанию.Номенклатура КАК Номенклатура,
|	ВтСпецификацииПоУмолчанию.Характеристика КАК ХарактеристикаНоменклатуры,
|	СУММА(ВтСпецификацииПоУмолчанию.Количество) КАК КоличествоИзделий,
|	СпецификацииСостав.Номенклатура КАК Пакет,
|	СпецификацииСостав.Характеристика КАК ХарактеристикаПакета,
|	СУММА(СпецификацииСостав.Количество * ВтСпецификацииПоУмолчанию.Количество) КАК Количество
|ПОМЕСТИТЬ ВтУпаковкиПродукции
|ИЗ
|	ВтСпецификацииПоУмолчанию КАК ВтСпецификацииПоУмолчанию
|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Спецификации.Состав КАК СпецификацииСостав
|			ЛЕВОЕ СОЕДИНЕНИЕ ВТБезСтолешниц КАК ВТБезСтолешниц
|			ПО (ИСТИНА)
|		ПО ВтСпецификацииПоУмолчанию.Спецификация = СпецификацииСостав.Ссылка
|ГДЕ
|	ВЫБОР
|			КОГДА ЕСТЬNULL(ВТБезСтолешниц.Значение, ЛОЖЬ)
|				ТОГДА НЕ СпецификацииСостав.Номенклатура В ИЕРАРХИИ (&Столешницы)
|			ИНАЧЕ ИСТИНА
|		КОНЕЦ
|	И СпецификацииСостав.Номенклатура.Родитель.Код <> ""НФ-00000039""
|
|СГРУППИРОВАТЬ ПО
|	СпецификацииСостав.Номенклатура,
|	СпецификацииСостав.Характеристика,
|	ВтСпецификацииПоУмолчанию.Номенклатура,
|	ВтСпецификацииПоУмолчанию.Характеристика
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ВтЗапасы.Номенклатура КАК Номенклатура,
|	ВЫБОР
|		КОГДА ВтЗапасы.Номенклатура = &Рекл
|			ТОГДА ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
|		ИНАЧЕ ВтЗапасы.Характеристика
|	КОНЕЦ КАК Характеристика,
|	СУММА(ВтЗапасы.Количество) КАК Количество
|ПОМЕСТИТЬ ВтУпаковки
|ИЗ
|	ВтЗапасы КАК ВтЗапасы
|ГДЕ
|	ВтЗапасы.Номенклатура.Изготовитель <> &Основное
|
|СГРУППИРОВАТЬ ПО
|	ВтЗапасы.Номенклатура,
|	ВЫБОР
|		КОГДА ВтЗапасы.Номенклатура = &Рекл
|			ТОГДА ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
|		ИНАЧЕ ВтЗапасы.Характеристика
|	КОНЕЦ
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	втУпаковкиПродукции.Номенклатура КАК Номенклатура,
|	втУпаковкиПродукции.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
|	втУпаковкиПродукции.КоличествоИзделий КАК КоличествоИзделий,
|	втУпаковкиПродукции.Пакет КАК Пакет,
|	втУпаковкиПродукции.ХарактеристикаПакета КАК ХарактеристикаПакета,
|	втУпаковкиПродукции.Количество КАК Количество
|ПОМЕСТИТЬ ВтРезультат
|ИЗ
|	ВтУпаковкиПродукции КАК втУпаковкиПродукции
|
|ОБЪЕДИНИТЬ ВСЕ
|
|ВЫБРАТЬ
|	ВтУпаковки.Номенклатура,
|	ВтУпаковки.Характеристика,
|	ВтУпаковки.Количество,
|	ВтУпаковки.Номенклатура,
|	ВтУпаковки.Характеристика,
|	ВтУпаковки.Количество
|ИЗ
|	ВтУпаковки КАК ВтУпаковки
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ВтЗапасы.Номенклатура КАК Номенклатура,
|	ВтЗапасы.Характеристика КАК ХарактеристикаНоменклатуры,
|	ВтЗапасы.Количество КАК КоличествоИзделий,
|	ХарактеристикиНоменклатурыДополнительныеРеквизиты.Значение КАК Пакет,
|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ХарактеристикаПакета,
|	ВтЗапасы.Количество КАК Количество
|ПОМЕСТИТЬ ВТФурнитура
|ИЗ
|	ВтЗапасы КАК ВтЗапасы
|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры.ДополнительныеРеквизиты КАК ХарактеристикиНоменклатурыДополнительныеРеквизиты
|		ПО ВтЗапасы.Номенклатура = ХарактеристикиНоменклатурыДополнительныеРеквизиты.Ссылка.Владелец
|			И ВтЗапасы.Характеристика = ХарактеристикиНоменклатурыДополнительныеРеквизиты.Ссылка.Ссылка
|ГДЕ
|	ХарактеристикиНоменклатурыДополнительныеРеквизиты.Свойство.Имя = ""КомплектФурнитуры""
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ВтРезультат.Номенклатура КАК Номенклатура,
|	ВтРезультат.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
|	СУММА(ВтРезультат.КоличествоИзделий) КАК КоличествоИзделий,
|	ВтРезультат.Пакет КАК Пакет,
|	ВтРезультат.ХарактеристикаПакета КАК ХарактеристикаПакета,
|	СУММА(ВтРезультат.Количество) КАК Количество
|ПОМЕСТИТЬ втрез
|ИЗ
|	ВтРезультат КАК ВтРезультат
|ГДЕ
|	ВтРезультат.Пакет.Изготовитель <> &Основное
|	И ВтРезультат.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
|
|СГРУППИРОВАТЬ ПО
|	ВтРезультат.Номенклатура,
|	ВтРезультат.ХарактеристикаНоменклатуры,
|	ВтРезультат.Пакет,
|	ВтРезультат.ХарактеристикаПакета
|
|ОБЪЕДИНИТЬ ВСЕ
|
|ВЫБРАТЬ
|	ВТФурнитура.Номенклатура,
|	ВТФурнитура.ХарактеристикаНоменклатуры,
|	ВТФурнитура.КоличествоИзделий,
|	ВТФурнитура.Пакет,
|	ВТФурнитура.ХарактеристикаПакета,
|	ВТФурнитура.Количество
|ИЗ
|	ВТФурнитура КАК ВТФурнитура
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	втрез.Номенклатура КАК Номенклатура,
|	втрез.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
|	ВЫБОР
|		КОГДА втрез.Номенклатура = &Рекл
|			ТОГДА 1
|		ИНАЧЕ втрез.КоличествоИзделий
|	КОНЕЦ КАК КоличествоИзделий,
|	втрез.Пакет КАК Пакет,
|	втрез.ХарактеристикаПакета КАК ХарактеристикаПакета,
|	ВЫБОР
|		КОГДА втрез.Номенклатура = &Рекл
|			ТОГДА 1
|		ИНАЧЕ втрез.Количество
|	КОНЕЦ КАК Количество
|ИЗ
|	втрез КАК втрез";

	
		Запрос.УстановитьПараметр("Столешницы", Справочники.Номенклатура.НайтиПоКоду("НФ-00001319"));
		Запрос.УстановитьПараметр("Рекл", Справочники.Номенклатура.НайтиПоКоду("НФ-0006240"));
		Запрос.УстановитьПараметр("Полуфабрикаты", Справочники.Номенклатура.НайтиПоКоду("НФ-00000003"));
		Запрос.УстановитьПараметр("Материалы", Справочники.Номенклатура.НайтиПоКоду("НФ-00000013"));
		Запрос.УстановитьПараметр("ГлавныйЗаказ", ГлавныйЗаказ);	
	Запрос.УстановитьПараметр("Основное", Справочники.СтруктурныеЕдиницы.НайтиПоНаименованию("Основное"));
	Возврат Запрос.Выполнить().Выгрузить();	
КонецФункции
