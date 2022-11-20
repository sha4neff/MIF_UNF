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

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//   Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаРасходныйОрдер, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	РасходныйОрдерЗапасы.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	РасходныйОрдерЗапасы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	РасходныйОрдерЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА &УчетПоЯчейкам
	|			ТОГДА РасходныйОрдерЗапасы.Ссылка.Ячейка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Ячейка,
	|	РасходныйОрдерЗапасы.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &ИспользоватьХарактеристики
	|			ТОГДА РасходныйОрдерЗапасы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ИспользоватьПартии
	|			ТОГДА РасходныйОрдерЗапасы.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Партия,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(РасходныйОрдерЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА РасходныйОрдерЗапасы.Количество
	|		ИНАЧЕ РасходныйОрдерЗапасы.Количество * РасходныйОрдерЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ КАК Количество
	|ИЗ
	|	Документ.РасходныйОрдер.Запасы КАК РасходныйОрдерЗапасы
	|ГДЕ
	|	РасходныйОрдерЗапасы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаЗапасы.Ссылка.Дата КАК ДатаСобытия,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийныхНомеров.Расход) КАК Операция,
	|	ТаблицаСерийныеНомера.СерийныйНомер КАК СерийныйНомер,
	|	&Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.Ссылка.Ячейка КАК Ячейка,
	|	1 КАК Количество
	|ИЗ
	|	Документ.РасходныйОрдер.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйОрдер.СерийныеНомера КАК ТаблицаСерийныеНомера
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерийныеНомера.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерийныеНомера.КлючСвязи
	|ГДЕ
	|	ТаблицаСерийныеНомера.Ссылка = &Ссылка
	|	И ТаблицаЗапасы.Ссылка = &Ссылка
	|	И &ИспользоватьСерийныеНомера
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаЗапасы.Ссылка.Дата КАК ДатаСобытия,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийныхНомеров.Расход) КАК Операция,
	|	ТаблицаСерийныеНомера.СерийныйНомер КАК СерийныйНомер,
	|	&Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.Ссылка.Ячейка КАК Ячейка,
	|	1 КАК Количество
	|ИЗ
	|	Документ.РасходныйОрдер.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйОрдер.СерийныеНомера КАК ТаблицаСерийныеНомера
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерийныеНомера.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерийныеНомера.КлючСвязи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СерийныеНомера.Остатки(&Дата, Организация = &Организация) КАК СерийныеНомераОстатки
	|		ПО ТаблицаЗапасы.Номенклатура = СерийныеНомераОстатки.Номенклатура
	|			И ТаблицаЗапасы.Характеристика = СерийныеНомераОстатки.Характеристика
	|			И ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница = СерийныеНомераОстатки.СтруктурнаяЕдиница
	|			И ТаблицаЗапасы.Партия = СерийныеНомераОстатки.Партия
	|			И (ТаблицаСерийныеНомера.СерийныйНомер = СерийныеНомераОстатки.СерийныйНомер)
	|ГДЕ
	|	ТаблицаСерийныеНомера.Ссылка = &Ссылка
	|	И ТаблицаЗапасы.Ссылка = &Ссылка
	|	И &ИспользоватьСерийныеНомера
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаЗапасы.Ссылка.Дата КАК ДатаСобытия,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийныхНомеров.Расход) КАК Операция,
	|	ТаблицаСерийныеНомера.СерийныйНомер КАК СерийныйНомер,
	|	&Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.Ссылка.Ячейка КАК Ячейка,
	|	1 КАК Количество
	|ИЗ
	|	Документ.РасходныйОрдер.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйОрдер.СерийныеНомера КАК ТаблицаСерийныеНомера
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерийныеНомера.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерийныеНомера.КлючСвязи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СерийныеНомераКРасходу.Остатки(&Дата, Организация = &Организация) КАК СерийныеНомераКРасходуОстатки
	|		ПО ТаблицаЗапасы.Номенклатура = СерийныеНомераКРасходуОстатки.Номенклатура
	|			И ТаблицаЗапасы.Характеристика = СерийныеНомераКРасходуОстатки.Характеристика
	|			И ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница = СерийныеНомераКРасходуОстатки.СтруктурнаяЕдиница
	|			И ТаблицаЗапасы.Партия = СерийныеНомераКРасходуОстатки.Партия
	|			И (ТаблицаСерийныеНомера.СерийныйНомер = СерийныеНомераКРасходуОстатки.СерийныйНомер)
	|ГДЕ
	|	ТаблицаСерийныеНомера.Ссылка = &Ссылка
	|	И ТаблицаЗапасы.Ссылка = &Ссылка
	|	И &ИспользоватьСерийныеНомера");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаРасходныйОрдер);
	Запрос.УстановитьПараметр("Дата", СтруктураДополнительныеСвойства.ДляПроведения.Дата);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("ИспользоватьХарактеристики", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьХарактеристики);
	Запрос.УстановитьПараметр("УчетПоЯчейкам", СтруктураДополнительныеСвойства.УчетнаяПолитика.УчетПоЯчейкам);
	Запрос.УстановитьПараметр("ИспользоватьПартии", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьПартии);
	
	Запрос.УстановитьПараметр("ИспользоватьСерийныеНомера", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьСерийныеНомера);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыНаСкладах", МассивРезультатов[0].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыКРасходуСоСкладов", МассивРезультатов[0].Выгрузить());
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераГарантии", МассивРезультатов[1].Выгрузить());
	Если СтруктураДополнительныеСвойства.УчетнаяПолитика.ОстаткиСерийныхНомеров Тогда
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераОстатки", МассивРезультатов[2].Выгрузить());
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераКРасходу", МассивРезультатов[3].Выгрузить());
	Иначе
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераОстатки", Новый ТаблицаЗначений);
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераКРасходу", Новый ТаблицаЗначений);
	КонецЕсли; 
	
	УправлениеНебольшойФирмойСервер.СформироватьТаблицуПроводок(ДокументСсылкаРасходныйОрдер, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаРасходныйОрдер, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если Не УправлениеНебольшойФирмойСервер.ВыполнитьКонтрольОстатков() Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Если временные таблицы "ДвиженияЗапасыНаСкладахИзменение", "ДвиженияЗапасыИзменение"
	// содержат записи, необходимо выполнить контроль реализации товаров.
	
	Если СтруктураВременныеТаблицы.ДвиженияЗапасыНаСкладахИзменение 
		ИЛИ СтруктураВременныеТаблицы.ДвиженияСерийныеНомераИзменение Тогда

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
		|	ДвиженияСерийныеНомераИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияСерийныеНомераИзменение.СерийныйНомер КАК СерийныйНомерПредставление,
		|	ДвиженияСерийныеНомераИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиницаПредставление,
		|	ДвиженияСерийныеНомераИзменение.Номенклатура КАК НоменклатураПредставление,
		|	ДвиженияСерийныеНомераИзменение.Характеристика КАК ХарактеристикаПредставление,
		|	ДвиженияСерийныеНомераИзменение.Партия КАК ПартияПредставление,
		|	СерийныеНомераКРасходуОстатки.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы,
		|	СерийныеНомераКРасходуОстатки.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияСерийныеНомераИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(СерийныеНомераКРасходуОстатки.КоличествоОстаток, 0) КАК ОстатокСерийныеНомера,
		|	ЕСТЬNULL(СерийныеНомераКРасходуОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокСерийныеНомера
		|ИЗ
		|	ДвиженияСерийныеНомераИзменение КАК ДвиженияСерийныеНомераИзменение
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СерийныеНомераКРасходу.Остатки(&МоментКонтроля, ) КАК СерийныеНомераКРасходуОстатки
		|		ПО ДвиженияСерийныеНомераИзменение.СтруктурнаяЕдиница = СерийныеНомераКРасходуОстатки.СтруктурнаяЕдиница
		|			И ДвиженияСерийныеНомераИзменение.Номенклатура = СерийныеНомераКРасходуОстатки.Номенклатура
		|			И ДвиженияСерийныеНомераИзменение.Характеристика = СерийныеНомераКРасходуОстатки.Характеристика
		|			И ДвиженияСерийныеНомераИзменение.Партия = СерийныеНомераКРасходуОстатки.Партия
		|			И ДвиженияСерийныеНомераИзменение.СерийныйНомер = СерийныеНомераКРасходуОстатки.СерийныйНомер
		|			И (ЕСТЬNULL(СерийныеНомераКРасходуОстатки.КоличествоОстаток, 0) < 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если НЕ МассивРезультатов[0].Пустой()
			ИЛИ НЕ МассивРезультатов[1].Пустой() Тогда
				ДокументОбъектРасходныйОрдер = ДокументСсылкаРасходныйОрдер.ПолучитьОбъект()
		КонецЕсли;
		
		// Отрицательный остаток запасов на складе.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструЗапасыНаСкладах(ДокументОбъектРасходныйОрдер, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток учета серийных номеров.
		Если НЕ МассивРезультатов[1].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструСерийныеНомера(ДокументОбъектРасходныйОрдер, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток учета серийных номеров к расходу.
		Если НЕ МассивРезультатов[2].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструСерийныеНомераКРасходу(ДокументОбъектРасходныйОрдер, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

#Область ИнтерфейсПечати

Функция УниверсальныйЗапросПоДаннымДокумента(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"
	// :::Шапка
	|ВЫБРАТЬ
	|	РасходныйОрдер.Ссылка КАК Ссылка
	|	,""Расходный ордер"" КАК ПредставлениеРегистратора
	|	,РасходныйОрдер.Номер КАК Номер
	|	,РасходныйОрдер.Дата КАК ДатаДокумента
	|	,РасходныйОрдер.СтруктурнаяЕдиница КАК ПредставлениеСклада
	|	,РасходныйОрдер.Ячейка КАК ПредставлениеЯчейки
	|	,РасходныйОрдер.Организация.Префикс КАК Префикс
	|
	// :::Табличная часть "Запасы"
	|	,РасходныйОрдер.Запасы.(
	|		НомерСтроки КАК НомерСтроки
	|		,Неопределено КАК Содержание
	|		,Выбор КОГДА(ВЫРАЗИТЬ(РасходныйОрдер.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|			ТОГДА РасходныйОрдер.Запасы.Номенклатура.Наименование
	|			ИНАЧЕ ВЫРАЗИТЬ(РасходныйОрдер.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КОНЕЦ КАК ПредставлениеНоменклатуры
	|		,Характеристика
	|		,Номенклатура.Артикул КАК Артикул
	|		,Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры
	|		,Номенклатура.Склад КАК Склад
	|		,Номенклатура.Ячейка КАК Ячейка
	|		,ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|		,Количество КАК Количество
	|		,КлючСвязи
	|	) КАК ТаблицаЗапасы
	|
	// :::Табличная часть "СерийныеНомера"
	|	,РасходныйОрдер.СерийныеНомера.(
	|		СерийныйНомер
	|		,КлючСвязи
	|	) КАК ТаблицаСерийныеНомера
	|ИЗ Документ.РасходныйОрдер КАК РасходныйОрдер
	|ГДЕ РасходныйОрдер.Ссылка В(&МассивОбъектов)
	|УПОРЯДОЧИТЬ ПО Ссылка, НомерСтроки";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура СформироватьРасходныйОрдер(ПечатнаяФорма, МассивОбъектов, ОбъектыПечати)
	Перем ПервыйДокумент, НомерСтрокиНачало, Ошибки;
	
	ПараметрыНоменклатуры = Новый Структура;
	
	ТабличныйДокумент = ПечатнаяФорма.ТабличныйДокумент;
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПечатнаяФорма.ПолныйПутьКМакету);
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходныйОрдер.Дата КАК ДатаДокумента,
		|	РасходныйОрдер.Организация КАК Организация,
		|	РасходныйОрдер.Номер КАК Номер,
		|	РасходныйОрдер.Организация.Префикс КАК Префикс,
		|	РасходныйОрдер.ПодписьКладовщика.Должность КАК ДолжностьКладовщика,
		|	РасходныйОрдер.ПодписьКладовщика.РасшифровкаПодписи КАК РасшифровкаПодписиКладовщика,
		|	РасходныйОрдер.Запасы.(
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура.НаименованиеПолное КАК Запас,
		|		Номенклатура.Код КАК Код,
		|		Номенклатура.Артикул КАК Артикул,
		|		ЕдиницаИзмерения КАК ЕдиницаХранения,
		|		Количество КАК Количество,
		|		Характеристика,
		|		КлючСвязи
		|	),
		|	РасходныйОрдер.СерийныеНомера.(
		|		СерийныйНомер,
		|		КлючСвязи
		|	)
		|ИЗ
		|	Документ.РасходныйОрдер КАК РасходныйОрдер
		|ГДЕ
		|	РасходныйОрдер.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		ВыборкаСтрокЗапасы = Шапка.Запасы.Выбрать();
		ВыборкаСтрокСерийныеНомера = Шапка.СерийныеНомера.Выбрать();
		
		СведенияОбОрганизации = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента, ,);
		
		НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(Шапка.ДатаДокумента, Шапка.Номер, Шапка.Префикс);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = "Расходный ордер № "
			+ НомерДокумента
			+ " от "
			+ Формат(Шапка.ДатаДокумента, "ДЛФ=DD");
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.ПредставлениеПолучателя = УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		Количество = 0;
		Пока ВыборкаСтрокЗапасы.Следующий() Цикл
			
			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокЗапасы);
			
			СтрокаСерийныеНомера = РаботаССерийнымиНомерами.СтрокаСерийныеНомераИзВыборки(ВыборкаСтрокСерийныеНомера, ВыборкаСтрокЗапасы.КлючСвязи);
			ОбластьМакета.Параметры.Запас = УправлениеНебольшойФирмойСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаСтрокЗапасы.Запас, 
				ВыборкаСтрокЗапасы.Характеристика, ВыборкаСтрокЗапасы.Артикул, СтрокаСерийныеНомера);
			
			ОбластьМакета.Параметры.ПредставлениеКодаНоменклатуры = ПечатьДокументовУНФ.ПредставлениеКодаНоменклатуры(ВыборкаСтрокЗапасы);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			Количество = Количество + 1;
			
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
КонецПроцедуры

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
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "РасходныйОрдер");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		ПечатнаяФорма.ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасходныйОрдер_РасходныйОрдер";
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РасходныйОрдер.ПФ_MXL_РасходныйОрдер";
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Расходный ордер'");
		
		СформироватьРасходныйОрдер(ПечатнаяФорма, МассивОбъектов, ОбъектыПечати);
		
	КонецЕсли;
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "БланкТоварногоНаполнения");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		ПечатнаяФорма.ТабличныйДокумент.КлючПараметровПечати = Обработки.ПечатьБланкТоварногоНаполнения.КлючПараметровПечати();
		ПечатнаяФорма.ПолныйПутьКМакету = Обработки.ПечатьБланкТоварногоНаполнения.ПолныйПутьКМакету();
		ПечатнаяФорма.СинонимМакета = Обработки.ПечатьБланкТоварногоНаполнения.ПредставлениеПФ();
		
		ДанныеОбъектовПечати = УниверсальныйЗапросПоДаннымДокумента(МассивОбъектов);
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
	КомандаПечати.Идентификатор = "РасходныйОрдер";
	КомандаПечати.Представление = НСтр("ru = 'Расходный ордер'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "БланкТоварногоНаполнения";
	КомандаПечати.Представление = Обработки.ПечатьБланкТоварногоНаполнения.ПредставлениеПФ();
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 4;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли