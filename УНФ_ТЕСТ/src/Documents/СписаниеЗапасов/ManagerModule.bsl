#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаЗапасы(ДокументСсылкаСписаниеЗапасов, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	// Установка исключительной блокировки контролируемых остатков запасов.
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаЗапасы.Организация КАК Организация,
	|	ТаблицаЗапасы.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.СчетУчета КАК СчетУчета,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка) КАК ЗаказПокупателя
	|ИЗ
	|	ВременнаяТаблицаЗапасы КАК ТаблицаЗапасы
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗапасы.Организация,
	|	ТаблицаЗапасы.СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.СчетУчета,
	|	ТаблицаЗапасы.Номенклатура,
	|	ТаблицаЗапасы.Характеристика,
	|	ТаблицаЗапасы.Партия";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.Запасы");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;

	Для каждого КолонкаРезультатЗапроса Из РезультатЗапроса.Колонки Цикл
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных(КолонкаРезультатЗапроса.Имя, КолонкаРезультатЗапроса.Имя);
	КонецЦикла;
	Блокировка.Заблокировать();
	
	// Получение остатков запасов по стоимости.
	Запрос.Текст = 	
	"ВЫБРАТЬ
	|	ЗапасыОстатки.Организация КАК Организация,
	|	ЗапасыОстатки.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыОстатки.СчетУчета КАК СчетУчета,
	|	ЗапасыОстатки.Номенклатура КАК Номенклатура,
	|	ЗапасыОстатки.Характеристика КАК Характеристика,
	|	ЗапасыОстатки.Партия КАК Партия,
	|	СУММА(ЗапасыОстатки.КоличествоОстаток) КАК КоличествоОстаток,
	|	СУММА(ЗапасыОстатки.СуммаОстаток) КАК СуммаОстаток
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗапасыОстатки.Организация КАК Организация,
	|		ЗапасыОстатки.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		ЗапасыОстатки.СчетУчета КАК СчетУчета,
	|		ЗапасыОстатки.Номенклатура КАК Номенклатура,
	|		ЗапасыОстатки.Характеристика КАК Характеристика,
	|		ЗапасыОстатки.Партия КАК Партия,
	|		СУММА(ЗапасыОстатки.КоличествоОстаток) КАК КоличествоОстаток,
	|		СУММА(ЗапасыОстатки.СуммаОстаток) КАК СуммаОстаток
	|	ИЗ
	|		РегистрНакопления.Запасы.Остатки(
	|				&МоментКонтроля,
	|				(Организация, СтруктурнаяЕдиница, СчетУчета, Номенклатура, Характеристика, Партия, ЗаказПокупателя) В
	|					(ВЫБРАТЬ
	|						ТаблицаЗапасы.Организация,
	|						ТаблицаЗапасы.СтруктурнаяЕдиница,
	|						ТаблицаЗапасы.СчетУчета,
	|						ТаблицаЗапасы.Номенклатура,
	|						ТаблицаЗапасы.Характеристика,
	|						ТаблицаЗапасы.Партия,
	|						ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка) КАК ЗаказПокупателя
	|					ИЗ
	|						ВременнаяТаблицаЗапасы КАК ТаблицаЗапасы)) КАК ЗапасыОстатки
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ЗапасыОстатки.Организация,
	|		ЗапасыОстатки.СтруктурнаяЕдиница,
	|		ЗапасыОстатки.СчетУчета,
	|		ЗапасыОстатки.Номенклатура,
	|		ЗапасыОстатки.Характеристика,
	|		ЗапасыОстатки.Партия
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаЗапасы.Организация,
	|		ДвиженияДокументаЗапасы.СтруктурнаяЕдиница,
	|		ДвиженияДокументаЗапасы.СчетУчета,
	|		ДвиженияДокументаЗапасы.Номенклатура,
	|		ДвиженияДокументаЗапасы.Характеристика,
	|		ДвиженияДокументаЗапасы.Партия,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаЗапасы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|				ТОГДА ЕСТЬNULL(ДвиженияДокументаЗапасы.Количество, 0)
	|			ИНАЧЕ -ЕСТЬNULL(ДвиженияДокументаЗапасы.Количество, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаЗапасы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|				ТОГДА ЕСТЬNULL(ДвиженияДокументаЗапасы.Сумма, 0)
	|			ИНАЧЕ -ЕСТЬNULL(ДвиженияДокументаЗапасы.Сумма, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.Запасы КАК ДвиженияДокументаЗапасы
	|	ГДЕ
	|		ДвиженияДокументаЗапасы.Регистратор = &Ссылка
	|		И ДвиженияДокументаЗапасы.Период <= &ПериодКонтроля) КАК ЗапасыОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗапасыОстатки.Организация,
	|	ЗапасыОстатки.СтруктурнаяЕдиница,
	|	ЗапасыОстатки.СчетУчета,
	|	ЗапасыОстатки.Номенклатура,
	|	ЗапасыОстатки.Характеристика,
	|	ЗапасыОстатки.Партия";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаСписаниеЗапасов);
	Запрос.УстановитьПараметр("МоментКонтроля", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ПериодКонтроля", СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени.Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаЗапасыОстатки = РезультатЗапроса.Выгрузить();
	ТаблицаЗапасыОстатки.Индексы.Добавить("Организация,СтруктурнаяЕдиница,СчетУчета,Номенклатура,Характеристика,Партия");
	
	Для н = 0 По СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЗапасы.Количество() - 1 Цикл
		
		СтрокаТаблицаЗапасы = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЗапасы[н];
		
		СтруктураДляПоиска = Новый Структура;
		СтруктураДляПоиска.Вставить("Организация", СтрокаТаблицаЗапасы.Организация);
		СтруктураДляПоиска.Вставить("СтруктурнаяЕдиница", СтрокаТаблицаЗапасы.СтруктурнаяЕдиница);
		СтруктураДляПоиска.Вставить("СчетУчета", СтрокаТаблицаЗапасы.СчетУчета);
		СтруктураДляПоиска.Вставить("Номенклатура", СтрокаТаблицаЗапасы.Номенклатура);
		СтруктураДляПоиска.Вставить("Характеристика", СтрокаТаблицаЗапасы.Характеристика);
		СтруктураДляПоиска.Вставить("Партия", СтрокаТаблицаЗапасы.Партия);
		
		КоличествоТребуется = СтрокаТаблицаЗапасы.Количество;
		
		Если КоличествоТребуется > 0 Тогда
			
			МассивСтрокОстатков = ТаблицаЗапасыОстатки.НайтиСтроки(СтруктураДляПоиска);
			
			КоличествоОстаток = 0;
			СуммаОстаток = 0;
			
			Если МассивСтрокОстатков.Количество() > 0 Тогда
				КоличествоОстаток = МассивСтрокОстатков[0].КоличествоОстаток;
				СуммаОстаток = МассивСтрокОстатков[0].СуммаОстаток;
			КонецЕсли;
			
			Если КоличествоОстаток > 0 И КоличествоОстаток > КоличествоТребуется Тогда

				СуммаКСписанию = Окр(СуммаОстаток * КоличествоТребуется / КоличествоОстаток , 2, 1);

				МассивСтрокОстатков[0].КоличествоОстаток = МассивСтрокОстатков[0].КоличествоОстаток - КоличествоТребуется;
				МассивСтрокОстатков[0].СуммаОстаток = МассивСтрокОстатков[0].СуммаОстаток - СуммаКСписанию;

			ИначеЕсли КоличествоОстаток = КоличествоТребуется Тогда

				СуммаКСписанию = СуммаОстаток;

				МассивСтрокОстатков[0].КоличествоОстаток = 0;
				МассивСтрокОстатков[0].СуммаОстаток = 0;

			Иначе
				СуммаКСписанию = 0;	
			КонецЕсли;
	
			СтрокаТаблицаЗапасы.Сумма = СуммаКСписанию;
			СтрокаТаблицаЗапасы.Количество = КоличествоТребуется;
					
		КонецЕсли;
		
		// Сформируем проводки.
		Если Окр(СтрокаТаблицаЗапасы.Сумма, 2, 1) <> 0 Тогда
			СтрокаТаблицаУправленческий = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаУправленческий.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицаУправленческий, СтрокаТаблицаЗапасы);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // СформироватьТаблицаЗапасов()

Процедура СформироватьТаблицаЗапасыВРазрезеГТД(СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(ТаблицаЗапасыНаСкладах.НомерСтроки) КАК НомерСтроки
	|	,ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения
	|	,ТаблицаЗапасыНаСкладах.Период КАК Период
	|	,ТаблицаЗапасыНаСкладах.Организация КАК Организация
	|	,ТаблицаЗапасыНаСкладах.Номенклатура КАК Номенклатура
	|	,ТаблицаЗапасыНаСкладах.Характеристика КАК Характеристика
	|	,ТаблицаЗапасыНаСкладах.Партия КАК Партия
	|	,ТаблицаЗапасыНаСкладах.НомерГТД КАК НомерГТД
	|	,ТаблицаЗапасыНаСкладах.СтранаПроисхождения КАК СтранаПроисхождения
	|	,СУММА(ТаблицаЗапасыНаСкладах.Количество) КАК Количество
	|ИЗ
	|	ВременнаяТаблицаЗапасы КАК ТаблицаЗапасыНаСкладах
	|ГДЕ
	|	ТаблицаЗапасыНаСкладах.СтранаПроисхождения <> Значение(Справочник.СтраныМира.Россия)
	|	И ТаблицаЗапасыНаСкладах.СтранаПроисхождения <> Значение(Справочник.СтраныМира.ПустаяССылка)
	|	И ТаблицаЗапасыНаСкладах.НомерГТД <> Значение(Справочник.НомераГТД.ПустаяССылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗапасыНаСкладах.Период
	|	,ТаблицаЗапасыНаСкладах.Организация
	|	,ТаблицаЗапасыНаСкладах.Номенклатура
	|	,ТаблицаЗапасыНаСкладах.Характеристика
	|	,ТаблицаЗапасыНаСкладах.Партия
	|	,ТаблицаЗапасыНаСкладах.НомерГТД
	|	,ТаблицаЗапасыНаСкладах.СтранаПроисхождения";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыВРазрезеГТД", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаСписаниеЗапасов, СтруктураДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписаниеЗапасовЗапасы.НомерСтроки КАК НомерСтроки,
	|	СписаниеЗапасовЗапасы.КлючСвязи КАК КлючСвязи,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	СписаниеЗапасовЗапасы.Ссылка КАК Ссылка,
	|	СписаниеЗапасовЗапасы.Ссылка.Дата КАК Период,
	|	СписаниеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ОрдерныйСклад КАК ОрдерныйСклад,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический) КАК СценарийПланирования,
	|	СписаниеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	СписаниеЗапасовЗапасы.Ссылка.Ячейка КАК Ячейка,
	|	ВЫБОР
	|		КОГДА СписаниеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Склад)
	|				ИЛИ СписаниеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
	|				ИЛИ СписаниеЗапасовЗапасы.Ссылка.СписатьЗапасыИзЭксплуатации
	|			ТОГДА СписаниеЗапасовЗапасы.Номенклатура.СчетУчетаЗапасов
	|		ИНАЧЕ СписаниеЗапасовЗапасы.Номенклатура.СчетУчетаЗатрат
	|	КОНЕЦ КАК СчетУчета,
	|	СписаниеЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|	СписаниеЗапасовЗапасы.СтранаПроисхождения КАК СтранаПроисхождения,
	|	СписаниеЗапасовЗапасы.НомерГТД КАК НомерГТД,
	|	ВЫБОР
	|		КОГДА &ИспользоватьХарактеристики
	|			ТОГДА СписаниеЗапасовЗапасы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ИспользоватьПартии
	|			ТОГДА СписаниеЗапасовЗапасы.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Партия,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(СписаниеЗапасовЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА СписаниеЗапасовЗапасы.Количество
	|		ИНАЧЕ СписаниеЗапасовЗапасы.Количество * СписаниеЗапасовЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ КАК Количество,
	|	0 КАК Сумма,
	|	СписаниеЗапасовЗапасы.Ссылка.Корреспонденция КАК СчетДт,
	|	ВЫБОР
	|		КОГДА СписаниеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Склад)
	|				ИЛИ СписаниеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
	|				ИЛИ СписаниеЗапасовЗапасы.Ссылка.СписатьЗапасыИзЭксплуатации
	|			ТОГДА СписаниеЗапасовЗапасы.Номенклатура.СчетУчетаЗапасов
	|		ИНАЧЕ СписаниеЗапасовЗапасы.Номенклатура.СчетУчетаЗатрат
	|	КОНЕЦ КАК СчетКт,
	|	&СписаниеЗапасов КАК СодержаниеПроводки
	|ПОМЕСТИТЬ ВременнаяТаблицаЗапасы
	|ИЗ
	|	Документ.СписаниеЗапасов.Запасы КАК СписаниеЗапасовЗапасы
	|ГДЕ
	|	СписаниеЗапасовЗапасы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ТаблицаЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаЗапасы.Период КАК Период,
	|	ТаблицаЗапасы.Организация КАК Организация,
	|	ТаблицаЗапасы.СценарийПланирования КАК СценарийПланирования,
	|	ТаблицаЗапасы.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.СчетУчета КАК СчетУчета,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Ссылка КАК ДокументПродажи,
	|	ТаблицаЗапасы.СчетДт КАК СчетДт,
	|	ТаблицаЗапасы.СчетКт КАК СчетКт,
	|	ТаблицаЗапасы.СодержаниеПроводки КАК СодержаниеПроводки,
	|	ТаблицаЗапасы.СодержаниеПроводки КАК Содержание,
	|	СУММА(ТаблицаЗапасы.Количество) КАК Количество,
	|	СУММА(ТаблицаЗапасы.Сумма) КАК Сумма
	|ИЗ
	|	ВременнаяТаблицаЗапасы КАК ТаблицаЗапасы
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗапасы.Период,
	|	ТаблицаЗапасы.Ссылка,
	|	ТаблицаЗапасы.Организация,
	|	ТаблицаЗапасы.СценарийПланирования,
	|	ТаблицаЗапасы.СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.СчетУчета,
	|	ТаблицаЗапасы.Номенклатура,
	|	ТаблицаЗапасы.Характеристика,
	|	ТаблицаЗапасы.Партия,
	|	ТаблицаЗапасы.СодержаниеПроводки,
	|	ТаблицаЗапасы.СчетДт,
	|	ТаблицаЗапасы.СчетКт,
	|	ТаблицаЗапасы.СодержаниеПроводки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаЗапасы.Период КАК Период,
	|	ТаблицаЗапасы.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.Ячейка КАК Ячейка,
	|	ТаблицаЗапасы.Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Количество КАК Количество
	|ИЗ
	|	ВременнаяТаблицаЗапасы КАК ТаблицаЗапасы
	|ГДЕ
	|	ТаблицаЗапасы.ОрдерныйСклад = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаЗапасы.Период КАК Период,
	|	ТаблицаЗапасы.Организация КАК Организация,
	|	ТаблицаЗапасы.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Количество КАК Количество
	|ИЗ
	|	ВременнаяТаблицаЗапасы КАК ТаблицаЗапасы
	|ГДЕ
	|	ТаблицаЗапасы.ОрдерныйСклад = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаЗапасы.Период КАК ДатаСобытия,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийныхНомеров.Расход) КАК Операция,	
	|	ТаблицаСерийныеНомера.СерийныйНомер КАК СерийныйНомер,
	|	&Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.Ячейка КАК Ячейка,
	|	1 КАК Количество
	|ИЗ
	|	ВременнаяТаблицаЗапасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СписаниеЗапасов.СерийныеНомера КАК ТаблицаСерийныеНомера
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерийныеНомера.Ссылка
	|		И ТаблицаЗапасы.КлючСвязи = ТаблицаСерийныеНомера.КлючСвязи
	|ГДЕ
	|	ТаблицаСерийныеНомера.Ссылка = &Ссылка И ТаблицаЗапасы.Ссылка = &Ссылка
	|	И &ИспользоватьСерийныеНомера
	|	И НЕ ТаблицаЗапасы.ОрдерныйСклад";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаСписаниеЗапасов);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.Дляпроведения.Организация);
	Запрос.УстановитьПараметр("ИспользоватьХарактеристики", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьХарактеристики);
	Запрос.УстановитьПараметр("УчетПоЯчейкам", СтруктураДополнительныеСвойства.УчетнаяПолитика.УчетПоЯчейкам);
	Запрос.УстановитьПараметр("ИспользоватьПартии", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьПартии);
	
	Запрос.УстановитьПараметр("ИспользоватьСерийныеНомера", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьСерийныеНомера);
	
	Запрос.УстановитьПараметр("СписаниеЗапасов", НСтр("ru = 'Списание запасов'"));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасы", МассивРезультатов[1].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыНаСкладах", МассивРезультатов[2].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыКРасходуСоСкладов", МассивРезультатов[3].Выгрузить());
	
	// Серийные номера
	РезультатЗапроса4 = МассивРезультатов[4].Выгрузить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераГарантии", РезультатЗапроса4);
	Если СтруктураДополнительныеСвойства.УчетнаяПолитика.ОстаткиСерийныхНомеров Тогда
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераОстатки", РезультатЗапроса4);
	Иначе
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераОстатки", Новый ТаблицаЗначений);
	КонецЕсли; 
	
	// Сформируем путую таблицу проводок.
	УправлениеНебольшойФирмойСервер.СформироватьТаблицуПроводок(ДокументСсылкаСписаниеЗапасов, СтруктураДополнительныеСвойства);
	
	// Расчет стоимости списания запасов.
	СформироватьТаблицаЗапасы(ДокументСсылкаСписаниеЗапасов, СтруктураДополнительныеСвойства);
	СформироватьТаблицаЗапасыВРазрезеГТД(СтруктураДополнительныеСвойства);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаЗапасы.Период,
	|	ВЫРАЗИТЬ(&Ссылка КАК Документ.СписаниеЗапасов) КАК Регистратор,
	|	ТаблицаЗапасы.Номенклатура,
	|	ТаблицаЗапасы.Сумма
	|ПОМЕСТИТЬ ТаблицаЗапасы
	|ИЗ
	|	&ТаблицаЗапасы КАК ТаблицаЗапасы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Период КАК Период,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Прочее) КАК НаправлениеДеятельности,
	|	СУММА(ТаблицаЗапасы.Сумма) КАК СуммаРасходов,
	|	СУММА(ТаблицаЗапасы.Сумма) КАК Сумма,
	|	ТаблицаЗапасы.Регистратор.Корреспонденция КАК СчетУчета,
	|	ТаблицаЗапасы.Номенклатура КАК Аналитика,
	|	&ПоступлениеРасходов КАК СодержаниеПроводки
	|ИЗ
	|	ТаблицаЗапасы КАК ТаблицаЗапасы
	|ГДЕ
	|	ТаблицаЗапасы.Регистратор.Корреспонденция.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗапасы.Регистратор,
	|	ТаблицаЗапасы.Период,
	|	ТаблицаЗапасы.Регистратор.Корреспонденция,
	|	ТаблицаЗапасы.Номенклатура");
	
	Запрос.УстановитьПараметр("ТаблицаЗапасы", СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЗапасы);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаСписаниеЗапасов);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.Дляпроведения.Организация);
	Запрос.УстановитьПараметр("ПоступлениеРасходов", НСтр("ru = 'Прочие расходы'"));
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходы", Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаСписаниеЗапасов, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если Не УправлениеНебольшойФирмойСервер.ВыполнитьКонтрольОстатков() Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Если временные таблицы "ДвиженияЗапасыНаСкладахИзменение", "ДвиженияЗапасыИзменение"
	// содержат записи, необходимо выполнить контроль реализации товаров.
	Если СтруктураВременныеТаблицы.ДвиженияЗапасыНаСкладахИзменение
		ИЛИ СтруктураВременныеТаблицы.ДвиженияЗапасыИзменение
		ИЛИ СтруктураВременныеТаблицы.ДвиженияЗапасыВРазрезеГТДИзменение
		ИЛИ СтруктураВременныеТаблицы.ДвиженияСерийныеНомераИзменение
		Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыНаСкладахИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиницаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Партия) КАК ПартияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Ячейка) КАК ЯчейкаПредставление,
		|	ЗапасыНаСкладахОстатки.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗапасыНаСкладахОстатки.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияЗапасыНаСкладахИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасыНаСкладах,
		|	ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасыНаСкладах
		|ИЗ
		|	ДвиженияЗапасыНаСкладахИзменение КАК ДвиженияЗапасыНаСкладахИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыНаСкладах.Остатки(
		|				&МоментКонтроля,
		|				(Организация, СтруктурнаяЕдиница, Номенклатура, Характеристика, Партия, Ячейка) В
		|					(ВЫБРАТЬ
		|						ДвиженияЗапасыНаСкладахИзменение.Организация КАК Организация,
		|						ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|						ДвиженияЗапасыНаСкладахИзменение.Номенклатура КАК Номенклатура,
		|						ДвиженияЗапасыНаСкладахИзменение.Характеристика КАК Характеристика,
		|						ДвиженияЗапасыНаСкладахИзменение.Партия КАК Партия,
		|						ДвиженияЗапасыНаСкладахИзменение.Ячейка КАК Ячейка
		|					ИЗ
		|						ДвиженияЗапасыНаСкладахИзменение КАК ДвиженияЗапасыНаСкладахИзменение)) КАК ЗапасыНаСкладахОстатки
		|		ПО ДвиженияЗапасыНаСкладахИзменение.Организация = ЗапасыНаСкладахОстатки.Организация
		|			И ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница = ЗапасыНаСкладахОстатки.СтруктурнаяЕдиница
		|			И ДвиженияЗапасыНаСкладахИзменение.Номенклатура = ЗапасыНаСкладахОстатки.Номенклатура
		|			И ДвиженияЗапасыНаСкладахИзменение.Характеристика = ЗапасыНаСкладахОстатки.Характеристика
		|			И ДвиженияЗапасыНаСкладахИзменение.Партия = ЗапасыНаСкладахОстатки.Партия
		|			И ДвиженияЗапасыНаСкладахИзменение.Ячейка = ЗапасыНаСкладахОстатки.Ячейка
		|ГДЕ
		|	ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияЗапасыИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиницаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.СчетУчета) КАК СчетУчетаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.Партия) КАК ПартияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.ЗаказПокупателя) КАК ЗаказПокупателяПредставление,
		|	ЗапасыОстатки.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗапасыОстатки.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияЗапасыИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(ЗапасыОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасы,
		|	ЕСТЬNULL(ЗапасыОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасы,
		|	ЕСТЬNULL(ЗапасыОстатки.СуммаОстаток, 0) КАК СуммаОстатокЗапасы
		|ИЗ
		|	ДвиженияЗапасыИзменение КАК ДвиженияЗапасыИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Запасы.Остатки(
		|				&МоментКонтроля,
		|				(Организация, СтруктурнаяЕдиница, СчетУчета, Номенклатура, Характеристика, Партия, ЗаказПокупателя) В
		|					(ВЫБРАТЬ
		|						ДвиженияЗапасыИзменение.Организация КАК Организация,
		|						ДвиженияЗапасыИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|						ДвиженияЗапасыИзменение.СчетУчета КАК СчетУчета,
		|						ДвиженияЗапасыИзменение.Номенклатура КАК Номенклатура,
		|						ДвиженияЗапасыИзменение.Характеристика КАК Характеристика,
		|						ДвиженияЗапасыИзменение.Партия КАК Партия,
		|						ДвиженияЗапасыИзменение.ЗаказПокупателя КАК ЗаказПокупателя
		|					ИЗ
		|						ДвиженияЗапасыИзменение КАК ДвиженияЗапасыИзменение)) КАК ЗапасыОстатки
		|		ПО ДвиженияЗапасыИзменение.Организация = ЗапасыОстатки.Организация
		|			И ДвиженияЗапасыИзменение.СтруктурнаяЕдиница = ЗапасыОстатки.СтруктурнаяЕдиница
		|			И ДвиженияЗапасыИзменение.СчетУчета = ЗапасыОстатки.СчетУчета
		|			И ДвиженияЗапасыИзменение.Номенклатура = ЗапасыОстатки.Номенклатура
		|			И ДвиженияЗапасыИзменение.Характеристика = ЗапасыОстатки.Характеристика
		|			И ДвиженияЗапасыИзменение.Партия = ЗапасыОстатки.Партия
		|			И ДвиженияЗапасыИзменение.ЗаказПокупателя = ЗапасыОстатки.ЗаказПокупателя
		|ГДЕ
		|	ЕСТЬNULL(ЗапасыОстатки.КоличествоОстаток, 0) < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияСерийныеНомераИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияСерийныеНомераИзменение.СерийныйНомер КАК СерийныйНомерПредставление,
		|	ДвиженияСерийныеНомераИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиницаПредставление,
		|	ДвиженияСерийныеНомераИзменение.Номенклатура КАК НоменклатураПредставление,
		|	ДвиженияСерийныеНомераИзменение.Характеристика КАК ХарактеристикаПредставление,
		|	ДвиженияСерийныеНомераИзменение.Партия КАК ПартияПредставление,
		|	ДвиженияСерийныеНомераИзменение.Ячейка КАК ЯчейкаПредставление,
		|	СерийныеНомераОстатки.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы,
		|	СерийныеНомераОстатки.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияСерийныеНомераИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(СерийныеНомераОстатки.КоличествоОстаток, 0) КАК ОстатокСерийныеНомера,
		|	ЕСТЬNULL(СерийныеНомераОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокСерийныеНомера
		|ИЗ
		|	ДвиженияСерийныеНомераИзменение КАК ДвиженияСерийныеНомераИзменение
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СерийныеНомера.Остатки(&МоментКонтроля, ) КАК СерийныеНомераОстатки
		|		ПО ДвиженияСерийныеНомераИзменение.СтруктурнаяЕдиница = СерийныеНомераОстатки.СтруктурнаяЕдиница
		|			И ДвиженияСерийныеНомераИзменение.Номенклатура = СерийныеНомераОстатки.Номенклатура
		|			И ДвиженияСерийныеНомераИзменение.Характеристика = СерийныеНомераОстатки.Характеристика
		|			И ДвиженияСерийныеНомераИзменение.Партия = СерийныеНомераОстатки.Партия
		|			И ДвиженияСерийныеНомераИзменение.СерийныйНомер = СерийныеНомераОстатки.СерийныйНомер
		|			И ДвиженияСерийныеНомераИзменение.Ячейка = СерийныеНомераОстатки.Ячейка
		|			И (ЕСТЬNULL(СерийныеНомераОстатки.КоличествоОстаток, 0) < 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияЗапасыВРазрезеГТДИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.НомерГТД) КАК НомерГТДПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.Партия) КАК ПартияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.СтранаПроисхождения) КАК СтранаПроисхожденияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗапасыВРазрезеГТДОстатки.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияЗапасыВРазрезеГТДИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(ЗапасыВРазрезеГТДОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасыВРазрезеГТД,
		|	ЕСТЬNULL(ЗапасыВРазрезеГТДОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасыВРазрезеГТД
		|ИЗ
		|	ДвиженияЗапасыВРазрезеГТДИзменение КАК ДвиженияЗапасыВРазрезеГТДИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыВРазрезеГТД.Остатки(
		|				&МоментКонтроля,
		|				(Организация, НомерГТД, Номенклатура, Характеристика, Партия, СтранаПроисхождения) В
		|					(ВЫБРАТЬ
		|						ДвиженияЗапасыВРазрезеГТДИзменение.Организация КАК Организация,
		|						ДвиженияЗапасыВРазрезеГТДИзменение.НомерГТД КАК НомерГТД,
		|						ДвиженияЗапасыВРазрезеГТДИзменение.Номенклатура КАК Номенклатура,
		|						ДвиженияЗапасыВРазрезеГТДИзменение.Характеристика КАК Характеристика,
		|						ДвиженияЗапасыВРазрезеГТДИзменение.Партия КАК Партия,
		|						ДвиженияЗапасыВРазрезеГТДИзменение.СтранаПроисхождения КАК СтранаПроисхождения
		|					ИЗ
		|						ДвиженияЗапасыВРазрезеГТДИзменение КАК ДвиженияЗапасыВРазрезеГТДИзменение)) КАК ЗапасыВРазрезеГТДОстатки
		|		ПО ДвиженияЗапасыВРазрезеГТДИзменение.Организация = ЗапасыВРазрезеГТДОстатки.Организация
		|			И ДвиженияЗапасыВРазрезеГТДИзменение.НомерГТД = ЗапасыВРазрезеГТДОстатки.НомерГТД
		|			И ДвиженияЗапасыВРазрезеГТДИзменение.Номенклатура = ЗапасыВРазрезеГТДОстатки.Номенклатура
		|			И ДвиженияЗапасыВРазрезеГТДИзменение.Характеристика = ЗапасыВРазрезеГТДОстатки.Характеристика
		|			И ДвиженияЗапасыВРазрезеГТДИзменение.Партия = ЗапасыВРазрезеГТДОстатки.Партия
		|			И ДвиженияЗапасыВРазрезеГТДИзменение.СтранаПроисхождения = ЗапасыВРазрезеГТДОстатки.СтранаПроисхождения
		|ГДЕ
		|	ЕСТЬNULL(ЗапасыВРазрезеГТДОстатки.КоличествоОстаток, 0) < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если НЕ МассивРезультатов[0].Пустой()
			ИЛИ НЕ МассивРезультатов[1].Пустой()
			ИЛИ НЕ МассивРезультатов[2].Пустой()
			ИЛИ НЕ МассивРезультатов[3].Пустой()
			Тогда
			
			ДокументОбъектСписаниеЗапасов = ДокументСсылкаСписаниеЗапасов.ПолучитьОбъект()
			
		КонецЕсли;
		
		// Отрицательный остаток запасов на складе.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструЗапасыНаСкладах(ДокументОбъектСписаниеЗапасов, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток учета запасов и затрат.
		Если НЕ МассивРезультатов[1].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструЗапасы(ДокументОбъектСписаниеЗапасов, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток учета серийных номеров.
		Если НЕ МассивРезультатов[2].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструСерийныеНомера(ДокументОбъектСписаниеЗапасов, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток по остаткам запасов в разрезе номеров ГТД.
		Если Константы.КонтролироватьОстаткиПоНомерамГТД.Получить()
			И НЕ МассивРезультатов[3].Пустой() Тогда
			
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструЗапасыВРазрезеГТД(ДокументОбъектСписаниеЗапасов, ВыборкаИзРезультатаЗапроса, Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

#Область ИнтерфейсПечати

Функция ДанныеДокументовБланкТоварногоНаполнения(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписаниеЗапасов.Ссылка КАК Ссылка
	|	,""Списание запасов"" КАК ПредставлениеРегистратора
	|	,СписаниеЗапасов.Дата КАК ДатаДокумента
	|	,СписаниеЗапасов.СтруктурнаяЕдиница КАК ПредставлениеСклада
	|	,СписаниеЗапасов.Номер
	|	,СписаниеЗапасов.Ячейка КАК ПредставлениеЯчейки
	|	,СписаниеЗапасов.Организация.Префикс КАК Префикс
	|	,""Запасы"" КАК ТипНоменклатурыТаблицы
	|	,СписаниеЗапасов.Запасы.(
	|		НомерСтроки КАК НомерСтроки
	|		,Номенклатура.Склад КАК Склад
	|		,Номенклатура.Ячейка КАК Ячейка
	|		,Неопределено КАК Содержание
	|		,Выбор КОГДА ВЫРАЗИТЬ(СписаниеЗапасов.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(100)) = """"
	|			ТОГДА СписаниеЗапасов.Запасы.Номенклатура.Наименование
	|			ИНАЧЕ СписаниеЗапасов.Запасы.Номенклатура.НаименованиеПолное КОНЕЦ КАК ПредставлениеНоменклатуры
	|		,Номенклатура.Артикул КАК Артикул
	|		,Номенклатура.Код КАК Код
	|		,ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения
	|		,Количество КАК Количество
	|		,Характеристика
	|		,Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры
	|		,КлючСвязи
	|	) КАК ТаблицаЗапасы
	|	,СписаниеЗапасов.СерийныеНомера.(
	|		СерийныйНомер,
	|		КлючСвязи
	|	) КАК ТаблицаСерийныеНомера
	|ИЗ Документ.СписаниеЗапасов КАК СписаниеЗапасов
	|ГДЕ СписаниеЗапасов.Ссылка В(&МассивОбъектов)
	|УПОРЯДОЧИТЬ ПО НомерСтроки";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "БланкТоварногоНаполнения");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		ПечатнаяФорма.ТабличныйДокумент.КлючПараметровПечати = Обработки.ПечатьБланкТоварногоНаполнения.КлючПараметровПечати();
		ПечатнаяФорма.ПолныйПутьКМакету = Обработки.ПечатьБланкТоварногоНаполнения.ПолныйПутьКМакету();
		ПечатнаяФорма.СинонимМакета = Обработки.ПечатьБланкТоварногоНаполнения.ПредставлениеПФ();
		
		ДанныеОбъектовПечати = ДанныеДокументовБланкТоварногоНаполнения(МассивОбъектов);
		Обработки.ПечатьБланкТоварногоНаполнения.СформироватьПФ(ПечатнаяФорма, ДанныеОбъектовПечати, ОбъектыПечати);
		
	КонецЕсли;
	
	// параметры отправки печатных форм по электронной почте
	УправлениеНебольшойФирмойСервер.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "БланкТоварногоНаполнения";
	КомандаПечати.Представление = Обработки.ПечатьБланкТоварногоНаполнения.ПредставлениеПФ();
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли