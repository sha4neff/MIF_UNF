#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик заполнения на основании элемента справочника ВнеоборотныеАктивы.
//
// Параметры:
//	СправочникСсылкаВнеоборотныеАктивы - СправочникСсылка.ВнеоборотныеАктивы.
//	
Процедура ЗаполнитьПоВнеоборотныеАктивы(СправочникСсылкаВнеоборотныеАктивы) Экспорт
	
	НоваяСтрока = ВнеоборотныеАктивы.Добавить();
	
	НоваяСтрока.ВнеоборотныйАктив = СправочникСсылкаВнеоборотныеАктивы;
	
	РассчитатьАмортизацию(СправочникСсылкаВнеоборотныеАктивы);
	
КонецПроцедуры // ЗаполнитьПоВнеоборотныеАктивы()

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("СправочникСсылка.ВнеоборотныеАктивы")] = "ЗаполнитьПоВнеоборотныеАктивы";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Выполнение предварительного контроля.
	ВыполнитьПредварительныйКонтроль(Отказ);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.СписаниеВА.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьСостоянияВнеоборотныхАктивов(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьВнеоборотныеАктивы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательных остатков.
	Документы.СписаниеВА.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательных остатков.
	Документы.СписаниеВА.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет предварительный контроль.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	// Дубли строк.
	Запрос = Новый Запрос();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.ВнеоборотныйАктив
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаДокумента1.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаДокумента1.ВнеоборотныйАктив
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокумента КАК ТаблицаДокумента2
	|		ПО ТаблицаДокумента1.НомерСтроки <> ТаблицаДокумента2.НомерСтроки
	|			И ТаблицаДокумента1.ВнеоборотныйАктив = ТаблицаДокумента2.ВнеоборотныйАктив
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента1.ВнеоборотныйАктив
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ТаблицаДокумента", ВнеоборотныеАктивы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = НСтр(
				"ru = 'Имущество ""%ВнеоборотныйАктив%"" указанное в строке %НомерСтроки% списка ""Имущество"", указано повторно.'"
			);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", ВыборкаИзРезультатаЗапроса.НомерСтроки);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВнеоборотныйАктив%", ВыборкаИзРезультатаЗапроса.ВнеоборотныйАктив);
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ВнеоборотныеАктивы",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ВнеоборотныйАктив",
				Отказ
			);
		
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("СписокВнеоборотныхАктивов", ВнеоборотныеАктивы.ВыгрузитьКолонку("ВнеоборотныйАктив"));
	
	// Проверка состояний имущества.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|ИЗ
	|	РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(, Организация = &Организация) КАК СостояниеВнеоборотногоАктиваСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|ИЗ
	|	(ВЫБРАТЬ
	|		СостояниеВнеоборотногоАктива.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|		СУММА(ВЫБОР
	|				КОГДА СостояниеВнеоборотногоАктива.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВнеоборотныхАктивов.ПринятКУчету)
	|					ТОГДА 1
	|				ИНАЧЕ -1
	|			КОНЕЦ) КАК ТекущееСостояние
	|	ИЗ
	|		РегистрСведений.СостоянияВнеоборотныхАктивов КАК СостояниеВнеоборотногоАктива
	|	ГДЕ
	|		СостояниеВнеоборотногоАктива.Регистратор <> &Ссылка
	|		И СостояниеВнеоборотногоАктива.Организация = &Организация
	|		И СостояниеВнеоборотногоАктива.ВнеоборотныйАктив В(&СписокВнеоборотныхАктивов)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		СостояниеВнеоборотногоАктива.ВнеоборотныйАктив) КАК ВложенныйЗапрос
	|ГДЕ
	|	ВложенныйЗапрос.ТекущееСостояние > 0";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	МассивВАСостояния = МассивРезультатов[0].Выгрузить().ВыгрузитьКолонку("ВнеоборотныйАктив");
	МассивВАПринятКУчету = МассивРезультатов[1].Выгрузить().ВыгрузитьКолонку("ВнеоборотныйАктив");
	
	Для каждого СтрокаВнеоборотныхАктивов Из ВнеоборотныеАктивы Цикл
		
		Если МассивВАСостояния.Найти(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив) = Неопределено Тогда
			ТекстСообщения = НСтр(
				"ru = 'Для имущества ""%ВнеоборотныйАктив%"" указанного в строке %НомерСтроки% списка ""Имущество"", не зарегистрированы состояния.'"
			);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВнеоборотныйАктив%", СокрЛП(Строка(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив))); 
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%",Строка(СтрокаВнеоборотныхАктивов.НомерСтроки));
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки,
				"ВнеоборотныйАктив",
				Отказ
			);
		ИначеЕсли МассивВАПринятКУчету.Найти(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив) = Неопределено Тогда
			ТекстСообщения = НСтр(
				"ru = 'Для имущества ""%ВнеоборотныйАктив%"" указанного в строке %НомерСтроки% списка ""Имущество"", текущее состояние ""Снят с учета"".'"
			);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВнеоборотныйАктив%", СокрЛП(Строка(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив))); 
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%",Строка(СтрокаВнеоборотныхАктивов.НомерСтроки));
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки,
				"ВнеоборотныйАктив",
				Отказ
			);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ВыполнитьПредварительныйКонтроль()

// Рассчитывает амортизацию имущества.
//
Процедура РассчитатьАмортизацию(ВнеоборотныйАктив)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.Регистратор.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних КАК ПараметрыВнеоборотныхАктивовСрезПоследних
	|ГДЕ
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.ВнеоборотныйАктив = &ВнеоборотныйАктив";
	
	Запрос.УстановитьПараметр("ВнеоборотныйАктив", ВнеоборотныйАктив);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Организация = Выборка.Организация;
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокАмортизируемыхВА.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ПРЕДСТАВЛЕНИЕ(СписокАмортизируемыхВА.ВнеоборотныйАктив) КАК ВнеоборотныйАктивПредставление,
	|	СписокАмортизируемыхВА.ВнеоборотныйАктив.Код КАК Код,
	|	СписокАмортизируемыхВА.НачалоНачислятьАмортизацию КАК НачалоНачислятьАмортизацию,
	|	СписокАмортизируемыхВА.КонецНачислятьАмортизацию КАК КонецНачислятьАмортизацию,
	|	СписокАмортизируемыхВА.КонецНачислятьВТекущемМесяце КАК КонецНачислятьВТекущемМесяце,
	|	ЕСТЬNULL(СтоимостьВА.АмортизацияКонечныйОстаток, 0) КАК АмортизацияКонечныйОстаток,
	|	ЕСТЬNULL(СтоимостьВА.АмортизацияОборот, 0) КАК АмортизацияОборот,
	|	ЕСТЬNULL(СтоимостьВА.СтоимостьКонечныйОстаток, 0) КАК БалансоваяСтоимость,
	|	ЕСТЬNULL(СтоимостьВА.СтоимостьНачальныйОстаток, 0) КАК СтоимостьНачальныйОстаток,
	|	ЕСТЬNULL(АмортизацияОстаткиИОбороты.СтоимостьНачальныйОстаток, 0) - ЕСТЬNULL(АмортизацияОстаткиИОбороты.АмортизацияНачальныйОстаток, 0) КАК СтоимостьНаНачалоГода,
	|	ЕСТЬNULL(СписокАмортизируемыхВА.ВнеоборотныйАктив.СпособАмортизации, 0) КАК СпособНачисленияАмортизации,
	|	ЕСТЬNULL(СписокАмортизируемыхВА.ВнеоборотныйАктив.НачальнаяСтоимость, 0) КАК ПервоначальнаяСтоимость,
	|	ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце, 0) КАК ПрименитьВТекущемМесяце,
	|	ПараметрыАмортизацииСрезПоследних.Период КАК Период,
	|	ВЫБОР
	|		КОГДА ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце
	|			ТОГДА ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.СрокИспользованияДляВычисленияАмортизации, 0)
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииСрезПоследнихНачалоМесяца.СрокИспользованияДляВычисленияАмортизации, 0)
	|	КОНЕЦ КАК СрокИспользованияДляВычисленияАмортизации,
	|	ВЫБОР
	|		КОГДА ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце
	|			ТОГДА ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.СтоимостьДляВычисленияАмортизации, 0)
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииСрезПоследнихНачалоМесяца.СтоимостьДляВычисленияАмортизации, 0)
	|	КОНЕЦ КАК СтоимостьДляВычисленияАмортизации,
	|	ЕСТЬNULL(ИзменениеПризнакаАмортизации.ИзменениеНачислАморт, ЛОЖЬ) КАК ИзменениеНачислАморт,
	|	ЕСТЬNULL(ИзменениеПризнакаАмортизации.НачислятьВТекМесяце, ЛОЖЬ) КАК НачислятьВТекМесяце,
	|	ЕСТЬNULL(ВыработкаВнеоборотногоАктиваОбороты.КоличествоОборот, 0) КАК ОбъемВыработки,
	|	ВЫБОР
	|		КОГДА ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце
	|			ТОГДА ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.ОбъемПродукцииРаботДляВычисленияАмортизации, 0)
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииСрезПоследнихНачалоМесяца.ОбъемПродукцииРаботДляВычисленияАмортизации, 0)
	|	КОНЕЦ КАК ОбъемПродукцииРаботДляВычисленияАмортизации
	|ПОМЕСТИТЬ ВременнаяТаблицаДляРасчетаАмортизации
	|ИЗ
	|	(ВЫБРАТЬ
	|		СрезПервых.НачислятьАмортизацию КАК НачалоНачислятьАмортизацию,
	|		СрезПоследних.НачислятьАмортизацию КАК КонецНачислятьАмортизацию,
	|		СрезПоследних.НачислятьАмортизациюВТекущемМесяце КАК КонецНачислятьВТекущемМесяце,
	|		СрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|	ИЗ
	|		(ВЫБРАТЬ
	|			СостояниеВнеоборотногоАктиваСрезПервых.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|			СостояниеВнеоборотногоАктиваСрезПервых.НачислятьАмортизацию КАК НачислятьАмортизацию,
	|			СостояниеВнеоборотногоАктиваСрезПервых.НачислятьАмортизациюВТекущемМесяце КАК НачислятьАмортизациюВТекущемМесяце,
	|			СостояниеВнеоборотногоАктиваСрезПервых.Период КАК Период
	|		ИЗ
	|			РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(
	|					&НачалоПериода,
	|					Организация = &Организация
	|						И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК СостояниеВнеоборотногоАктиваСрезПервых) КАК СрезПервых
	|			ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|				СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизацию КАК НачислятьАмортизацию,
	|				СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизациюВТекущемМесяце КАК НачислятьАмортизациюВТекущемМесяце,
	|				СостояниеВнеоборотногоАктиваСрезПоследних.Период КАК Период
	|			ИЗ
	|				РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(
	|						&КонецПериода,
	|						Организация = &Организация
	|							И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК СостояниеВнеоборотногоАктиваСрезПоследних) КАК СрезПоследних
	|			ПО СрезПервых.ВнеоборотныйАктив = СрезПоследних.ВнеоборотныйАктив) КАК СписокАмортизируемыхВА
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВнеоборотныеАктивы.ОстаткиИОбороты(
	|				&НачалоГода,
	|				,
	|				,
	|				,
	|				Организация = &Организация
	|					И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК АмортизацияОстаткиИОбороты
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = АмортизацияОстаткиИОбороты.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВнеоборотныеАктивы.ОстаткиИОбороты(
	|				&НачалоПериода,
	|				&КонецПериода,
	|				,
	|				,
	|				Организация = &Организация
	|					И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК СтоимостьВА
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = СтоимостьВА.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(
	|				&КонецПериода,
	|				Организация = &Организация
	|					И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК ПараметрыАмортизацииСрезПоследних
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ПараметрыАмортизацииСрезПоследних.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(
	|				&НачалоПериода,
	|				Организация = &Организация
	|					И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК ПараметрыАмортизацииСрезПоследнихНачалоМесяца
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ПараметрыАмортизацииСрезПоследнихНачалоМесяца.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ИСТИНА) КАК ИзменениеНачислАморт,
	|			СостояниеВнеоборотногоАктива.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|			СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизациюВТекущемМесяце КАК НачислятьВТекМесяце
	|		ИЗ
	|			РегистрСведений.СостоянияВнеоборотныхАктивов КАК СостояниеВнеоборотногоАктива
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(
	|						&КонецПериода,
	|						Организация = &Организация
	|							И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК СостояниеВнеоборотногоАктиваСрезПоследних
	|				ПО СостояниеВнеоборотногоАктива.ВнеоборотныйАктив = СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив
	|		ГДЕ
	|			СостояниеВнеоборотногоАктива.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|			И СостояниеВнеоборотногоАктива.Организация = &Организация
	|			И СостояниеВнеоборотногоАктива.ВнеоборотныйАктив В(&СписокВнеоборотныхАктивов)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			СостояниеВнеоборотногоАктива.ВнеоборотныйАктив,
	|			СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизациюВТекущемМесяце) КАК ИзменениеПризнакаАмортизации
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ИзменениеПризнакаАмортизации.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВыработкаВнеоборотныхАктивов.Обороты(
	|				&НачалоПериода,
	|				&КонецПериода,
	|				,
	|				Организация = &Организация
	|					И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК ВыработкаВнеоборотногоАктиваОбороты
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ВыработкаВнеоборотногоАктиваОбороты.ВнеоборотныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Организация КАК Организация,
	|	&Период КАК Период,
	|	Таблица.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	Таблица.ВнеоборотныйАктивПредставление КАК ВнеоборотныйАктивПредставление,
	|	Таблица.Код КАК Код,
	|	Таблица.АмортизацияКонечныйОстаток КАК АмортизацияКонечныйОстаток,
	|	Таблица.БалансоваяСтоимость КАК БалансоваяСтоимость,
	|	0 КАК Стоимость,
	|	ВЫБОР
	|		КОГДА ВЫБОР
	|				КОГДА Таблица.СуммаАмортизации < Таблица.ВсегоОсталосьСписать
	|					ТОГДА Таблица.СуммаАмортизации
	|				ИНАЧЕ Таблица.ВсегоОсталосьСписать
	|			КОНЕЦ > 0
	|			ТОГДА ВЫБОР
	|					КОГДА Таблица.СуммаАмортизации < Таблица.ВсегоОсталосьСписать
	|						ТОГДА Таблица.СуммаАмортизации
	|					ИНАЧЕ Таблица.ВсегоОсталосьСписать
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Амортизация
	|ПОМЕСТИТЬ ТаблицаРасчетаАмортизации
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЫБОР
	|			КОГДА Таблица.СпособНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииВнеоборотныхАктивов.Линейный)
	|				ТОГДА Таблица.СтоимостьДляВычисленияАмортизации / ВЫБОР
	|						КОГДА Таблица.СрокИспользованияДляВычисленияАмортизации = 0
	|							ТОГДА 1
	|						ИНАЧЕ Таблица.СрокИспользованияДляВычисленияАмортизации
	|					КОНЕЦ
	|			КОГДА Таблица.СпособНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииВнеоборотныхАктивов.ПропорциональноОбъемуПродукции)
	|				ТОГДА Таблица.СтоимостьДляВычисленияАмортизации * Таблица.ОбъемВыработки / ВЫБОР
	|						КОГДА Таблица.ОбъемПродукцииРаботДляВычисленияАмортизации = 0
	|							ТОГДА 1
	|						ИНАЧЕ Таблица.ОбъемПродукцииРаботДляВычисленияАмортизации
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК СуммаАмортизации,
	|		Таблица.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|		Таблица.ВнеоборотныйАктивПредставление КАК ВнеоборотныйАктивПредставление,
	|		Таблица.Код КАК Код,
	|		Таблица.АмортизацияКонечныйОстаток КАК АмортизацияКонечныйОстаток,
	|		Таблица.БалансоваяСтоимость КАК БалансоваяСтоимость,
	|		Таблица.БалансоваяСтоимость - Таблица.АмортизацияКонечныйОстаток КАК ВсегоОсталосьСписать
	|	ИЗ
	|		ВременнаяТаблицаДляРасчетаАмортизации КАК Таблица) КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВременнаяТаблицаДляРасчетаАмортизации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВнеоборотныеАктивы.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВнеоборотныеАктивы.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|ПОМЕСТИТЬ ТаблицаВнеоборотныеАктивы
	|ИЗ
	|	&ТаблицаВнеоборотныеАктивы КАК ТаблицаВнеоборотныеАктивы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВнеоборотныеАктивы.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВнеоборотныеАктивы.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ТаблицаРасчетаАмортизации.БалансоваяСтоимость КАК Стоимость,
	|	ТаблицаРасчетаАмортизации.Амортизация КАК АмортизацияЗаМесяц,
	|	ТаблицаРасчетаАмортизации.АмортизацияКонечныйОстаток КАК Амортизация,
	|	ТаблицаРасчетаАмортизации.БалансоваяСтоимость - ТаблицаРасчетаАмортизации.АмортизацияКонечныйОстаток КАК ОстаточнаяСтоимость
	|ИЗ
	|	ТаблицаВнеоборотныеАктивы КАК ТаблицаВнеоборотныеАктивы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаРасчетаАмортизации КАК ТаблицаРасчетаАмортизации
	|		ПО ТаблицаВнеоборотныеАктивы.ВнеоборотныйАктив = ТаблицаРасчетаАмортизации.ВнеоборотныйАктив
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТаблицаВнеоборотныеАктивы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТаблицаРасчетаАмортизации";
	
	ТекДата = ТекущаяДата();
	
	Запрос.УстановитьПараметр("Период", ТекДата);
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	Запрос.УстановитьПараметр("НачалоГода", НачалоГода(ТекДата));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ТекДата));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ТекДата));
	Запрос.УстановитьПараметр("СписокВнеоборотныхАктивов", ВнеоборотныеАктивы.ВыгрузитьКолонку("ВнеоборотныйАктив"));
	Запрос.УстановитьПараметр("ТаблицаВнеоборотныеАктивы", ВнеоборотныеАктивы);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ТаблицаАмортизации = РезультатЗапроса[4].Выгрузить();
	
	ВнеоборотныеАктивы.Загрузить(ТаблицаАмортизации);
	
КонецПроцедуры // РассчитатьАмортизацию()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли