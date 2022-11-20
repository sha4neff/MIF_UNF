#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		
		Возврат;
		
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗапасыПринятыеВРазрезеГТД.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПринятыеВРазрезеГТДИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПринятыеВРазрезеГТДИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗапасыПринятыеВРазрезеГТДИзменение Тогда
		
		// Если временная таблица "ДвиженияЗапасыПринятыеВРазрезеГТДИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗапасыПринятыеВРазрезеГТД.НомерСтроки КАК НомерСтроки,
		|	ЗапасыПринятыеВРазрезеГТД.Организация КАК Организация,
		|	ЗапасыПринятыеВРазрезеГТД.СтранаПроисхождения КАК СтранаПроисхождения,
		|	ЗапасыПринятыеВРазрезеГТД.Номенклатура КАК Номенклатура,
		|	ЗапасыПринятыеВРазрезеГТД.Характеристика КАК Характеристика,
		|	ЗапасыПринятыеВРазрезеГТД.Партия КАК Партия,
		|	ЗапасыПринятыеВРазрезеГТД.НомерГТД КАК НомерГТД,
		|	ВЫБОР
		|		КОГДА ЗапасыПринятыеВРазрезеГТД.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыПринятыеВРазрезеГТД.Количество
		|		ИНАЧЕ -ЗапасыПринятыеВРазрезеГТД.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью
		|ИЗ
		|	РегистрНакопления.ЗапасыПринятыеВРазрезеГТД КАК ЗапасыПринятыеВРазрезеГТД
		|ГДЕ
		|	ЗапасыПринятыеВРазрезеГТД.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗапасыПринятыеВРазрезеГТДИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблцу "ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Организация КАК Организация,
		|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.СтранаПроисхождения КАК СтранаПроисхождения,
		|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Партия КАК Партия,
		|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.НомерГТД КАК НомерГТД,
		|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью
		|ИЗ
		|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение КАК ДвиженияЗапасыПринятыеВРазрезеГТДИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗапасыПринятыеВРазрезеГТД.НомерСтроки,
		|	ЗапасыПринятыеВРазрезеГТД.Организация,
		|	ЗапасыПринятыеВРазрезеГТД.СтранаПроисхождения,
		|	ЗапасыПринятыеВРазрезеГТД.Номенклатура,
		|	ЗапасыПринятыеВРазрезеГТД.Характеристика,
		|	ЗапасыПринятыеВРазрезеГТД.Партия,
		|	ЗапасыПринятыеВРазрезеГТД.НомерГТД,
		|	ВЫБОР
		|		КОГДА ЗапасыПринятыеВРазрезеГТД.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыПринятыеВРазрезеГТД.Количество
		|		ИНАЧЕ -ЗапасыПринятыеВРазрезеГТД.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ЗапасыПринятыеВРазрезеГТД КАК ЗапасыПринятыеВРазрезеГТД
		|ГДЕ
		|	ЗапасыПринятыеВРазрезеГТД.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗапасыПринятыеВРазрезеГТДИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПринятыеВРазрезеГТДИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыПринятыеВРазрезеГТДИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗапасыПринятыеВРазрезеГТДИзменение");
	
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияЗапасыПринятыеВРазрезеГТДИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Организация КАК Организация,
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Характеристика КАК Характеристика,
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Партия КАК Партия,
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.НомерГТД КАК НомерГТД,
	|	СУММА(ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыПринятыеВРазрезеГТДИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью.Организация КАК Организация,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью.СтранаПроисхождения КАК СтранаПроисхождения,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью.Партия КАК Партия,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью.НомерГТД КАК НомерГТД,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью КАК ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.НомерСтроки,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.Организация,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.СтранаПроисхождения,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.Номенклатура,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.Характеристика,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.Партия,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.НомерГТД,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.ЗапасыПринятыеВРазрезеГТД КАК ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи
	|	ГДЕ
	|		ДвиженияЗапасыПринятыеВРазрезеГТДПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗапасыПринятыеВРазрезеГТДИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Организация,
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.СтранаПроисхождения,
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Номенклатура,
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Характеристика,
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.Партия,
	|	ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.НомерГТД
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияЗапасыПринятыеВРазрезеГТДИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	СтранаПроисхождения,
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	НомерГТД");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗапасыПринятыеВРазрезеГТДИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыПринятыеВРазрезеГТДИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыПринятыеВРазрезеГТДПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли