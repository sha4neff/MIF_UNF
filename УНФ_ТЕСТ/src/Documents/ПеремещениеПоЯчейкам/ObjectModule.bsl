#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Обработчик заполнения на основании документа ПриходнаяНакладная.
//
// Параметры:
//	ДокументСсылкаПриходнаяНакладная - ДокументСсылка.ПриходнаяНакладная.
//	
Процедура ЗаполнитьПоПриходнаяНакладная(ДокументСсылкаПриходнаяНакладная) Экспорт
	
	// Заполнение шапки.
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
	ДокументСсылкаПриходнаяНакладная,
	Новый Структура("Организация, СтруктурнаяЕдиница, Ячейка"));
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	ДокументОснование = ДокументСсылкаПриходнаяНакладная;
	ВидОперации = Перечисления.ВидыОперацийПеремещениеПоЯчейкам.ИзОднойВНесколько;
	
	// Заполнение табличной части.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПриходнаяНакладнаяЗапасы.Номенклатура КАК Номенклатура,
	|	ПриходнаяНакладнаяЗапасы.Характеристика КАК Характеристика,
	|	ПриходнаяНакладнаяЗапасы.Партия КАК Партия,
	|	ПриходнаяНакладнаяЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ПриходнаяНакладнаяЗапасы.Количество) КАК Количество,
	|	ПриходнаяНакладнаяЗапасы.СерийныеНомера КАК СерийныеНомера,
	|	ПриходнаяНакладнаяЗапасы.КлючСвязи КАК КлючСвязи
	|ИЗ
	|	Документ.ПриходнаяНакладная.Запасы КАК ПриходнаяНакладнаяЗапасы
	|ГДЕ
	|	ПриходнаяНакладнаяЗапасы.Ссылка = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	ПриходнаяНакладнаяЗапасы.Номенклатура,
	|	ПриходнаяНакладнаяЗапасы.Характеристика,
	|	ПриходнаяНакладнаяЗапасы.Партия,
	|	ПриходнаяНакладнаяЗапасы.ЕдиницаИзмерения,
	|	ПриходнаяНакладнаяЗапасы.СерийныеНомера,
	|	ПриходнаяНакладнаяЗапасы.КлючСвязи";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаПриходнаяНакладная);
	
	Запасы.Загрузить(Запрос.Выполнить().Выгрузить());
	
	РаботаССерийнымиНомерами.ЗаполнитьТЧСерийныеНомераПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаПриходнаяНакладная);
	
КонецПроцедуры // ЗаполнитьПоПриходнаяНакладная()

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ПриходнаяНакладная")] = "ЗаполнитьПоПриходнаяНакладная";
	
	Если ЭтоНовый() И ЗначениеЗаполнено(ДанныеЗаполнения) И ТипЗнч(ДанныеЗаполнения)=Тип("Структура") Тогда
		// Если указана ячейка, передаем как Склад - её владельца
		// Чтобы избежать ситуации, когда выбраны не связанные Склад и Ячейка в отборе
		Если ДанныеЗаполнения.Свойство("Ячейка") Тогда
			Если ТипЗнч(ДанныеЗаполнения.Ячейка) = Тип("Массив") Тогда
				ПоследняяЯчейка = ДанныеЗаполнения.Ячейка[ДанныеЗаполнения.Ячейка.Количество()-1];
				ДанныеЗаполнения.Вставить("СтруктурнаяЕдиница", ПоследняяЯчейка.Владелец);
			ИначеЕсли ТипЗнч(ДанныеЗаполнения.Ячейка) = Тип("СправочникСсылка.Ячейки") Тогда
				ДанныеЗаполнения.Вставить("СтруктурнаяЕдиница", ДанныеЗаполнения.Ячейка.Владелец);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.ПеремещениеПоЯчейкам.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	
	// СерийныеНомера
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераГарантии(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераОстатки(ДополнительныеСвойства, Движения, Отказ);

	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.ПеремещениеПоЯчейкам.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.ПеремещениеПоЯчейкам.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Серийные номера
	РаботаССерийнымиНомерами.ПроверкаЗаполненияСерийныхНомеров(Отказ, Запасы, СерийныеНомера, СтруктурнаяЕдиница, ЭтотОбъект);
	
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ, Истина);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли