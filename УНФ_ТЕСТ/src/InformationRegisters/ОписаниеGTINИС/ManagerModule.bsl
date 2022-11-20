#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание входящих GTIN
//
// Параметры:
//   GTIN - Строка, Массив Из Строка - GTIN для которых требуется получить описание ИС
//
// Возвращаемое значение:
//   Соответствие - найденные GTIN с их описанием:
//    * Ключ - - Строка - GTIN элемента,
//    * Значение - Структура - описание элемента:
//      ** Коэффициент - Число  - количество индивидуальных кодов маркировки в упаковке,
//      ** ВидУпаковки - ПеречислениеСсылка.ВидыУпаковокИС - вид упаковки.
Функция ПолучитьОписание(Знач GTIN) Экспорт
	
	Результат = Новый Соответствие;
	
	Если ТипЗнч(GTIN) = Тип("Строка") Тогда
		Параметр = Новый Массив;
		Параметр.Добавить(GTIN);
		GTIN = Параметр;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОписаниеGTINИС.GTIN        КАК GTIN,
		|	ОписаниеGTINИС.ВидУпаковки КАК ВидУпаковки,
		|	ОписаниеGTINИС.Коэффициент КАК Коэффициент
		|ИЗ
		|	РегистрСведений.ОписаниеGTINИС КАК ОписаниеGTINИС
		|ГДЕ
		|	ОписаниеGTINИС.GTIN В (&GTIN)");
	
	Запрос.УстановитьПараметр("GTIN", GTIN);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(
			Выборка.GTIN,
			Новый Структура(
				"ВидУпаковки, Коэффициент", Выборка.ВидУпаковки, Выборка.Коэффициент));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Сохраняет описание GTIN
//
// Параметры:
//   GTIN         - Строка - GTIN для которых требуется установить описание ИС,
//    Коэффициент - Число  - количество индивидуальных кодов маркировки в упаковке,
//    ВидУпаковки - ПеречислениеСсылка.ВидыУпаковокИС - вид упаковки.
//
Процедура УстановитьОписание(Знач GTIN, Знач Коэффициент, Знач ВидУпаковки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ОписаниеGTINИС.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.GTIN = GTIN;
	МенеджерЗаписи.Коэффициент = Коэффициент;
	МенеджерЗаписи.ВидУпаковки = ВидУпаковки;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Сохраняет описание GTIN, если ранее не было установлено, по переданный таблице данных.
//
// Параметры:
//   ТаблицаОписания - ТаблицаЗначений - Описание:
// 	* GTIN                - ОпределяемыйТип.GTIN                       - GTIN.
//  * ВидУпаковки         - ПеречислениеСсылка.ВидыУпаковокИС          - Вид упаковки.
//  * Коэффициент         - Число                                      - Коэффициент групповой упаковки.
//
Процедура УстановитьОписаниеПоТаблице(ТаблицаОписания) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИсходнаяТаблица.GTIN,
	|	ИсходнаяТаблица.ВидУпаковки,
	|	ИсходнаяТаблица.Коэффициент
	|ПОМЕСТИТЬ ИсходнаяТаблица
	|ИЗ
	|	&ИсходнаяТаблица КАК ИсходнаяТаблица
	|ГДЕ
	|	ИсходнаяТаблица.Коэффициент > 1
	|	И ИсходнаяТаблица.ВидУпаковки В (
	|		ЗНАЧЕНИЕ(Перечисление.ВидыУпаковокИС.Групповая),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыУпаковокИС.Логистическая))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходнаяТаблица.GTIN,
	|	ИсходнаяТаблица.ВидУпаковки,
	|	ИсходнаяТаблица.Коэффициент
	|ИЗ
	|	ИсходнаяТаблица КАК ИсходнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОписаниеGTINИС КАК ОписаниеGTINИС
	|		ПО ИсходнаяТаблица.GTIN = ОписаниеGTINИС.GTIN
	|ГДЕ
	|	ОписаниеGTINИС.GTIN ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("ИсходнаяТаблица", ТаблицаОписания);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		УстановитьОписание(
			ВыборкаДетальныеЗаписи.GTIN,
			ВыборкаДетальныеЗаписи.Коэффициент,
			ВыборкаДетальныеЗаписи.ВидУпаковки);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли