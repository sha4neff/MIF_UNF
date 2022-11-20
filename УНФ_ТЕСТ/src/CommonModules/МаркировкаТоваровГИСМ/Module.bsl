#Область ПрограммныйИнтерфейс

// Обновляет информацию о статусе ГИСМ на форме документа
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, в которой необходимо обновить статус ГИСМ
//  ИмяДокумента - Строка - Имя документа, для которого необходимо определить статус ГИСМ.
//
Процедура ОбновитьСтатусГИСМ(Форма, ИмяДокумента) Экспорт
	
	Форма.СтатусГИСМ          = Перечисления.СтатусыИнформированияГИСМ.Черновик;
	Форма.ДальнейшееДействие  = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПустаяСсылка();
	
	Если НЕ Форма.Объект.Ссылка.Пустая() Тогда
		
		Запрос = Новый Запрос;
		ТекстЗапроса = "ВЫБРАТЬ
		|	ЕСТЬNULL(СтатусыИнформированияГИСМ.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусыИнформированияГИСМ.Черновик)) КАК СтатусИнформированияГИСМ,
		|	ВЫБОР
		|		КОГДА СтатусыИнформированияГИСМ.ДальнейшееДействие В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПустаяСсылка)
		|		ИНАЧЕ ЕСТЬNULL(СтатусыИнформированияГИСМ.ДальнейшееДействие, &ДальнейшееДействие)
		|	КОНЕЦ КАК ДальнейшееДействие
		|ИЗ
		|	Документ.%ИмяДокумента% КАК МаркировкаТоваровГИСМ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
		|		ПО (СтатусыИнформированияГИСМ.Документ = МаркировкаТоваровГИСМ.Ссылка)
		|ГДЕ
		|	МаркировкаТоваровГИСМ.Ссылка = &Ссылка";
		
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "%ИмяДокумента%", ИмяДокумента);
		
		Запрос.УстановитьПараметр("Ссылка",                   Форма.Объект.Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияГИСМ.НеотображаемыеВДокументахДальнейшиеДействия());
		
		Если ИмяДокумента = "ПеремаркировкаТоваровГИСМ" Тогда
			Запрос.УстановитьПараметр("ДальнейшееДействие", Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеСписаниеКиЗ);
		Иначе
			Запрос.УстановитьПараметр("ДальнейшееДействие", Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные);
		КонецЕсли;
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Форма.СтатусГИСМ         = Выборка.СтатусИнформированияГИСМ;
			Форма.ДальнейшееДействие = Выборка.ДальнейшееДействие;
		КонецЕсли;
		
	Иначе
		
		Если ИмяДокумента = "ПеремаркировкаТоваровГИСМ" Тогда
			Форма.ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеСписаниеКиЗ;
		Иначе
			Форма.ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
		КонецЕсли;
		
	КонецЕсли;
	
	ДопустимыеДействия = Новый Массив;
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеМаркировкаТоваров);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеПеремаркировкаТоваров);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеСписаниеКиЗ);
	
	Форма.СтатусГИСМПредставление = ИнтеграцияГИСМ.ПредставлениеСтатусаГИСМ(
		Форма.СтатусГИСМ,
		Форма.ДальнейшееДействие,
		ДопустимыеДействия);
	
КонецПроцедуры

// Устанавливает/скрывает видимость полей в зависимости от операции идентификации
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, в которой необходимо управление видимостью.
//
Процедура УправлениеДоступностью(Форма) Экспорт
	
	ОперацияИдентификации = Форма.ОперацияИдентификации;
	
	Форма.Элементы.КиЗГИСМВид.Видимость = НЕ ОперацияИдентификации;
	Форма.Элементы.КиЗГИСМСпособВыпускаВОборот.Видимость = НЕ ОперацияИдентификации;
	Форма.Элементы.КиЗГИСМРазмер.Видимость = НЕ ОперацияИдентификации;
	Форма.Элементы.КиЗГИСМСИндивидуализацией.Видимость = НЕ ОперацияИдентификации;
	
	Форма.Элементы.ТоварыНоменклатураКиЗ.Видимость = НЕ ОперацияИдентификации;
	Форма.Элементы.ТоварыХарактеристикаКиЗ.Видимость = НЕ ОперацияИдентификации;
	
КонецПроцедуры

// Устанавливает/скрывает видимость полей в зависимости от операции идентификации
//
// Параметры:
//  ДокументОбъект - ДокументОбъект - Документ, в котором необходимо проверить соответствие GTIN КиЗ и товара 
//  Отказ - Булево - Признак, указывающий на необходимость установки стандартного флага Отказ при проверке.
//
Процедура ПроверитьСоответствияGTIN(ДокументОбъект, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	Товары.НомерСтроки,
		|	Товары.НоменклатураКиЗ,
		|	Товары.ХарактеристикаКиЗ,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.GTIN
		|ПОМЕСТИТЬ ВтТовары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки,
		|	Товары.НоменклатураКиЗ,
		|	Товары.ХарактеристикаКиЗ,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.GTIN,
		|	ЕСТЬNULL(Товары.ХарактеристикаКиЗ.КиЗГИСМGTIN, Товары.НоменклатураКиЗ.КиЗГИСМGTIN) КАК GTINКИЗ
		|ИЗ
		|	ВтТовары КАК Товары
		|ГДЕ
		|	ЕСТЬNULL(Товары.ХарактеристикаКиЗ.КиЗГИСМGTIN, Товары.НоменклатураКиЗ.КиЗГИСМGTIN) <> Товары.GTIN
		|	И НЕ ЕСТЬNULL(Товары.ХарактеристикаКиЗ.КиЗГИСМGTIN, Товары.НоменклатураКиЗ.КиЗГИСМGTIN) ПОДОБНО """"
		|";
		
	Запрос.УстановитьПараметр("Товары", ДокументОбъект.Товары.Выгрузить());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ШаблонСообщения = НСтр("ru='GTIN КиЗ %1 %2 отличается от GTIN товара %3 в строке %4.'");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения,
			ИнтеграцияИС.ПредставлениеНоменклатуры(Выборка.НоменклатураКиЗ, Выборка.ХарактеристикаКиЗ),
				СокрЛП(Выборка.GTINКИЗ),
			ИнтеграцияИС.ПредставлениеНоменклатуры(Выборка.Номенклатура, Выборка.Характеристика),
				СокрЛП(Выборка.GTIN));
			
		НомерСтроки = Выборка.НомерСтроки - 1;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ДокументОбъект.Ссылка,
			"Объект.Товары[" + НомерСтроки + "].GTIN",
			,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
