#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьДвиженияWMS(ПараметрыОтчета)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1 WMSСклады.Ссылка КАК Узел,WMSСклады.СкладWMS ИЗ ПланОбмена.БЗ_WMS.Склады КАК WMSСклады ГДЕ WMSСклады.Склад = &Склад";
	Запрос.УстановитьПараметр("Склад", Справочники.СтруктурныеЕдиницы.НайтиПоКоду("00-000001"));
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Если НЕ Выборка.Следующий() Тогда Возврат Неопределено;	КонецЕсли;
	УзелОбмена=Выборка.Узел.ПолучитьОбъект();
	СкладWMS=Выборка.СкладWMS;
	JSONПакет=Новый Структура();
	JSONПакет.Вставить("Тип","ПолучитьДвиженияПоСкладу2");
	JSONПакет.Вставить("КодБД",УзелОбмена.КодБД);
	JSONПакет.Вставить("НачДата",ПараметрыОтчета.ДатаНачала);
	JSONПакет.Вставить("КонДата",ПараметрыОтчета.ДатаОкончания);
	JSONПакет.Вставить("Номенклатура",?(ЗначениеЗаполнено(ПараметрыОтчета.Номенклатура),ПараметрыОтчета.Номенклатура.УникальныйИдентификатор(),""));
	JSONПакет.Вставить("ХарактеристикаНоменклатуры",?(ЗначениеЗаполнено(ПараметрыОтчета.Характеристика),ПараметрыОтчета.Характеристика.УникальныйИдентификатор(),""));
	JSONПакет.Вставить("СкладWMS",СкладWMS);
	JSONОтвет="";
	Результат=УзелОбмена.ВыполнитьОтправкуJSONПакета(ПланыОбмена.БЗ_MES.Записать_JSON(JSONПакет),JSONОтвет);
	Если Результат<>"ok" Тогда
		Сообщить("Ошибка получения данных от WMS");		
		Возврат Неопределено;
	КонецЕсли;
	ХранилищеДвижений = ЗначениеИзСтрокиВнутр(JSONОтвет.Движения);
	Если ТипЗнч(ХранилищеДвижений)<>Тип("ХранилищеЗначения") Тогда 
		Сообщить("Ошибка получения данных от WMS");		
		Возврат Неопределено;
	Иначе
		ТБДвижения =ХранилищеДвижений.Получить();
	КонецЕсли;	
	ТБДанные=Новый ТаблицаЗначений();
	ТБДанные.Колонки.Добавить("НомерСтрокиТовар",Новый ОписаниеТипов("Число"));
	ТБДанные.Колонки.Добавить("Номенклатура",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТБДанные.Колонки.Добавить("ХарактеристикаНоменклатуры",Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТБДанные.Колонки.Добавить("КоличествоНачальныйОстаток",Новый ОписаниеТипов("Число"));
	ТБДанные.Колонки.Добавить("КоличествоПриход",Новый ОписаниеТипов("Число"));
	ТБДанные.Колонки.Добавить("КоличествоРасход",Новый ОписаниеТипов("Число"));
	ТБДанные.Колонки.Добавить("КоличествоКонечныйОстаток",Новый ОписаниеТипов("Число"));
	ТБДанные.Колонки.Добавить("НомерСтрокиДокумент",Новый ОписаниеТипов("Число"));
	ТБДанные.Колонки.Добавить("Период",Новый ОписаниеТипов("Дата"));
	ТБДанные.Колонки.Добавить("Документ",Новый ОписаниеТипов("Строка"));
	ТБДанные.Колонки.Добавить("КИСGUID",Новый ОписаниеТипов("Строка"));
	ТБДанные.Колонки.Добавить("WMSGUID",Новый ОписаниеТипов("Строка"));
	ТБДанные.Колонки.Добавить("КИСДокумент",Новый ОписаниеТипов(Документы.ТипВсеСсылки()));  
	ТБДанные.Колонки.Добавить("КИСНомерПаллеты",Новый ОписаниеТипов("Число"));  
	ТБДанные.Колонки.Добавить("ДокументТип",Новый ОписаниеТипов("Число"));  
	ТБДанные.Колонки.Добавить("ДокКоличествоНачальныйОстаток",Новый ОписаниеТипов("Число"));
	ТБДанные.Колонки.Добавить("ДокКоличествоПриход",Новый ОписаниеТипов("Число"));
	ТБДанные.Колонки.Добавить("ДокКоличествоРасход",Новый ОписаниеТипов("Число"));
	ТБДанные.Колонки.Добавить("ДокКоличествоКонечныйОстаток",Новый ОписаниеТипов("Число"));			
	ТБДанные.Индексы.Добавить("Номенклатура,ХарактеристикаНоменклатуры");
	НомерСтрокиТовар = 0;
	ОПКоличествоТоваров=ТБДвижения.Количество()/100;
	Для Каждого JSДвижение Из ТБДвижения Цикл		
		Попытка
			JSНоменклатура=Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(JSДвижение.Номенклатура)).ПолучитьОбъект().Ссылка;			
			Если ЗначениеЗаполнено(JSДвижение.ХарактеристикаНоменклатуры) Тогда
				JSХарактеристикаНоменклатуры=Справочники.ХарактеристикиНоменклатуры.ПолучитьСсылку(Новый УникальныйИдентификатор(JSДвижение.ХарактеристикаНоменклатуры)).ПолучитьОбъект().Ссылка;
			Иначе
				JSХарактеристикаНоменклатуры=Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
			КонецЕсли;			
		Исключение
			Сообщить("Ошибка получения ссылки на товар с GUID: "+JSДвижение.Номенклатура+" / "+JSДвижение.ХарактеристикаНоменклатуры);
			Продолжить;
		КонецПопытки;
		НомерСтрокиТовар = НомерСтрокиТовар + 1;
		НомерСтрокиДокумент = 0;
		СТТовар=ТБДанные.Добавить();
		СТТовар.НомерСтрокиТовар = НомерСтрокиТовар;
		СТТовар.НомерСтрокиДокумент = НомерСтрокиДокумент;
		СТТовар.Номенклатура=JSНоменклатура;
		СТТовар.ХарактеристикаНоменклатуры=JSХарактеристикаНоменклатуры;
		СТТовар.КоличествоНачальныйОстаток=JSДвижение.КоличествоНачальныйОстаток;
		СТТовар.КоличествоПриход=JSДвижение.КоличествоПриход;
		СТТовар.КоличествоРасход=JSДвижение.КоличествоРасход;
		СТТовар.КоличествоКонечныйОстаток=JSДвижение.КоличествоКонечныйОстаток;			
		СТТовар.ДокументТип=2;
		Для Каждого JSДокумент Из JSДвижение.Документы Цикл
			НомерСтрокиДокумент = НомерСтрокиДокумент + 1;
			СТТовар=ТБДанные.Добавить();
			СТТовар.НомерСтрокиТовар = НомерСтрокиТовар;
			СТТовар.НомерСтрокиДокумент = НомерСтрокиДокумент;
			СТТовар.Номенклатура=JSНоменклатура;
			СТТовар.ХарактеристикаНоменклатуры=JSХарактеристикаНоменклатуры;
			СТТовар.ДокументТип=2;
			СТТовар.КоличествоНачальныйОстаток=JSДвижение.КоличествоНачальныйОстаток;
			СТТовар.КоличествоПриход=JSДвижение.КоличествоПриход;
			СТТовар.КоличествоРасход=JSДвижение.КоличествоРасход;
			СТТовар.КоличествоКонечныйОстаток=JSДвижение.КоличествоКонечныйОстаток;			
			СТТовар.Период=JSДокумент.Период;
			СТТовар.Документ=JSДокумент.Документ;
			JSКИСДокумент = Неопределено;
			Попытка   
				Если JSДокумент.Тип = "ОЗ" Тогда
					JSКИСДокумент = Документы.ОтгрузочнаяВедомость.ПолучитьСсылку(Новый УникальныйИдентификатор(JSДокумент.КИСGUID)).ПолучитьОбъект().Ссылка;
				КонецЕсли;	
			Исключение
				Сообщить("Ошибка получения ссылки на документ с GUID: "+JSДокумент.КИСGUID);
			КонецПопытки;
			СТТовар.WMSGUID=СокрЛП(JSДокумент.WMSGUID);
			СТТовар.КИСGUID=СокрЛП(JSДокумент.КИСGUID);
			СТТовар.КИСДокумент=JSКИСДокумент;
			СТТовар.ДокКоличествоНачальныйОстаток=JSДокумент.КоличествоНачальныйОстаток;
			СТТовар.ДокКоличествоПриход=JSДокумент.КоличествоПриход;
			СТТовар.ДокКоличествоРасход=JSДокумент.КоличествоРасход;
			СТТовар.ДокКоличествоКонечныйОстаток=JSДокумент.КоличествоКонечныйОстаток;			
		КонецЦикла;
	КонецЦикла;
	Возврат ТБДанные;
КонецФункции

Функция ПолучитьДвиженияУНФ(ПараметрыОтчета)
	Запрос = Новый Запрос;
	Если ЗначениеЗаполнено(ПараметрыОтчета.Номенклатура) Тогда
		Если ПараметрыОтчета.Номенклатура.ЭтоГруппа Тогда
			Фильтр="Номенклатура В ИЕРАРХИИ(&Номенклатура)";
			Запрос.УстановитьПараметр("Номенклатура", ПараметрыОтчета.Номенклатура);
		Иначе
			Запрос.УстановитьПараметр("Номенклатура", ПараметрыОтчета.Номенклатура);
			Фильтр="Номенклатура=&Номенклатура";
			Если ЗначениеЗаполнено(ПараметрыОтчета.Характеристика) Тогда
				Фильтр=Фильтр+" И Характеристика=&Характеристика";
				Запрос.УстановитьПараметр("Характеристика", ПараметрыОтчета.Характеристика);
			КонецЕсли;
		КонецЕсли;		
	Иначе
		Фильтр="ИСТИНА";
	КонецЕсли;	
	ЗапросТекст = 
"ВЫБРАТЬ
|	ТоварыНаСкладахОстаткиИОборотыТовары.Номенклатура КАК Номенклатура,
|	ТоварыНаСкладахОстаткиИОборотыТовары.Характеристика КАК ХарактеристикаНоменклатуры,
|	СУММА(ТоварыНаСкладахОстаткиИОборотыТовары.КоличествоНачальныйОстаток) КАК КоличествоНачальныйОстаток,
|	СУММА(ТоварыНаСкладахОстаткиИОборотыТовары.КоличествоПриход) КАК КоличествоПриход,
|	СУММА(ТоварыНаСкладахОстаткиИОборотыТовары.КоличествоРасход) КАК КоличествоРасход,
|	СУММА(ТоварыНаСкладахОстаткиИОборотыТовары.КоличествоКонечныйОстаток) КАК КоличествоКонечныйОстаток,
|	1 КАК ДокументТип,
|	ДАТАВРЕМЯ(1, 1, 1) КАК Период,
|	НЕОПРЕДЕЛЕНО КАК КИСДокумент,
|	0 КАК ДокКоличествоНачальныйОстаток,
|	0 КАК ДокКоличествоПриход,
|	0 КАК ДокКоличествоРасход,
|	0 КАК ДокКоличествоКонечныйОстаток
|ИЗ
|	РегистрНакопления.ЗапасыНаСкладах.ОстаткиИОбороты(
|			&НачДата,
|			&КонДата,
|			,
|			ДвиженияИГраницыПериода,
|			СтруктурнаяЕдиница В (&Склады)
|				И &Фильтр) КАК ТоварыНаСкладахОстаткиИОборотыТовары
|
|СГРУППИРОВАТЬ ПО
|	ТоварыНаСкладахОстаткиИОборотыТовары.Номенклатура,
|	ТоварыНаСкладахОстаткиИОборотыТовары.Характеристика
|
|ОБЪЕДИНИТЬ ВСЕ
|
|ВЫБРАТЬ
|	ТоварыНаСкладахОстаткиИОборотыТовары.Номенклатура,
|	ТоварыНаСкладахОстаткиИОборотыТовары.Характеристика,
|	СУММА(ТоварыНаСкладахОстаткиИОборотыТовары.КоличествоНачальныйОстаток),
|	СУММА(ТоварыНаСкладахОстаткиИОборотыТовары.КоличествоПриход),
|	СУММА(ТоварыНаСкладахОстаткиИОборотыТовары.КоличествоРасход),
|	СУММА(ТоварыНаСкладахОстаткиИОборотыТовары.КоличествоКонечныйОстаток),
|	1,
|	ТоварыНаСкладахОстаткиИОборотыДвижения.Период,
|	ТоварыНаСкладахОстаткиИОборотыДвижения.Регистратор,
|	СУММА(ЕСТЬNULL(ТоварыНаСкладахОстаткиИОборотыДвижения.КоличествоНачальныйОстаток, 0)),
|	СУММА(ЕСТЬNULL(ТоварыНаСкладахОстаткиИОборотыДвижения.КоличествоПриход, 0)),
|	СУММА(ЕСТЬNULL(ТоварыНаСкладахОстаткиИОборотыДвижения.КоличествоРасход, 0)),
|	СУММА(ЕСТЬNULL(ТоварыНаСкладахОстаткиИОборотыДвижения.КоличествоКонечныйОстаток, 0))
|ИЗ
|	РегистрНакопления.ЗапасыНаСкладах.ОстаткиИОбороты(
|			&НачДата,
|			&КонДата,
|			,
|			Движения,
|			СтруктурнаяЕдиница В (&Склады)
|				И &Фильтр) КАК ТоварыНаСкладахОстаткиИОборотыТовары
|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыНаСкладах.ОстаткиИОбороты(
|				&НачДата,
|				&КонДата,
|				Регистратор,
|				Движения,
|				СтруктурнаяЕдиница В (&Склады)
|					И &Фильтр) КАК ТоварыНаСкладахОстаткиИОборотыДвижения
|		ПО ТоварыНаСкладахОстаткиИОборотыТовары.Номенклатура = ТоварыНаСкладахОстаткиИОборотыДвижения.Номенклатура
|			И ТоварыНаСкладахОстаткиИОборотыТовары.Характеристика = ТоварыНаСкладахОстаткиИОборотыДвижения.Характеристика
|
|СГРУППИРОВАТЬ ПО
|	ТоварыНаСкладахОстаткиИОборотыТовары.Номенклатура,
|	ТоварыНаСкладахОстаткиИОборотыТовары.Характеристика,
|	ТоварыНаСкладахОстаткиИОборотыДвижения.Период,
|	ТоварыНаСкладахОстаткиИОборотыДвижения.Регистратор";
;
;	
	ЗапросТекст = СтрЗаменить(ЗапросТекст, "&Фильтр", Фильтр);	
	Склады = Новый Массив();
	Склады.Добавить(Справочники.СтруктурныеЕдиницы.НайтиПоКоду("00-000001"));	
	Склады.Добавить(Справочники.СтруктурныеЕдиницы.НайтиПоКоду("НФ-000053"));	
	Запрос.Текст = ЗапросТекст;	
	Запрос.УстановитьПараметр("НачДата", ПараметрыОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("КонДата", ПараметрыОтчета.ДатаОкончания);	
	Запрос.УстановитьПараметр("Склады", Склады);
	ТБДанные = Запрос.Выполнить().Выгрузить();
	Возврат ТБДанные;
КонецФункции

Функция ФорматЧислаДок(ЧислоДок)
	Возврат Формат(ЧислоДок,"ЧЦ=10; ЧН=' '; ЧГ=3,0");
КонецФункции

Функция ФорматЧислаТовар(ЧислоТовар)
	Возврат Формат(ЧислоТовар,"ЧЦ=10; ЧН=' '; ЧГ=3,0");
КонецФункции

Функция ПредставлениеТоварХарактеристика(Товар,Характеристика) Экспорт
	Попытка
		Если ЗначениеЗаполнено(Характеристика) Тогда
			Возврат СокрЛП(Товар.Наименование)+" //"+СокрЛП(Характеристика.Наименование)+"//";
		Иначе
			Возврат СокрЛП(Товар.Наименование);
		КонецЕсли;
	Исключение
		Возврат "";
	КонецПопытки;
КонецФункции

Процедура СформироватьОтчет(ПараметрыОтчета, АдресРезультата) Экспорт
	Отбор=Новый Структура();	
	ТБДвиженияWMS=ПолучитьДвиженияWMS(ПараметрыОтчета);
	Если ТБДвиженияWMS=Неопределено Тогда
		Возврат;
	КонецЕсли;	
	ТБДвиженияКИС=ПолучитьДвиженияУНФ(ПараметрыОтчета);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 	
	"ВЫБРАТЬ
	|	ТЗДвиженияWMS.Период КАК Период,
	|	ТЗДвиженияWMS.Номенклатура КАК Номенклатура,
	|	ТЗДвиженияWMS.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ВЫРАЗИТЬ(ТЗДвиженияWMS.Документ КАК СТРОКА(200)) КАК Документ,
	|	ВЫРАЗИТЬ(ТЗДвиженияWMS.КИСGUID КАК СТРОКА(36)) КАК КИСGUID,
	|	ВЫРАЗИТЬ(ТЗДвиженияWMS.WMSGUID КАК СТРОКА(36)) КАК WMSGUID,
	|	ТЗДвиженияWMS.КИСДокумент КАК КИСДокумент,
	|	ТЗДвиженияWMS.ДокументТип КАК ДокументТип,
	|	ТЗДвиженияWMS.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|	ТЗДвиженияWMS.КоличествоПриход КАК КоличествоПриход,
	|	ТЗДвиженияWMS.КоличествоРасход КАК КоличествоРасход,
	|	ТЗДвиженияWMS.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	|	ТЗДвиженияWMS.ДокКоличествоНачальныйОстаток КАК ДокКоличествоНачальныйОстаток,
	|	ТЗДвиженияWMS.ДокКоличествоПриход КАК ДокКоличествоПриход,
	|	ТЗДвиженияWMS.ДокКоличествоРасход КАК ДокКоличествоРасход,
	|	ТЗДвиженияWMS.ДокКоличествоКонечныйОстаток КАК ДокКоличествоКонечныйОстаток,
	|	ТЗДвиженияWMS.НомерСтрокиТовар КАК НомерСтрокиТовар,
	|	ТЗДвиженияWMS.НомерСтрокиДокумент КАК НомерСтрокиДокумент,
	|	ТЗДвиженияWMS.КИСНомерПаллеты КАК КИСНомерПаллеты
	|ПОМЕСТИТЬ ДвиженияWMS
	|ИЗ
	|	&ТЗДвиженияWMS КАК ТЗДвиженияWMS
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	КИСДокумент,
	|	WMSGUID
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЗДвиженияКИС.Период КАК Период,
	|	ТЗДвиженияКИС.Номенклатура КАК Номенклатура,
	|	ТЗДвиженияКИС.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТЗДвиженияКИС.КИСДокумент КАК КИСДокумент,
	|	ТЗДвиженияКИС.ДокументТип КАК ДокументТип,
	|	ТЗДвиженияКИС.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|	ТЗДвиженияКИС.КоличествоПриход КАК КоличествоПриход,
	|	ТЗДвиженияКИС.КоличествоРасход КАК КоличествоРасход,
	|	ТЗДвиженияКИС.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	|	ТЗДвиженияКИС.ДокКоличествоНачальныйОстаток КАК ДокКоличествоНачальныйОстаток,
	|	ТЗДвиженияКИС.ДокКоличествоПриход КАК ДокКоличествоПриход,
	|	ТЗДвиженияКИС.ДокКоличествоРасход КАК ДокКоличествоРасход,
	|	ТЗДвиженияКИС.ДокКоличествоКонечныйОстаток КАК ДокКоличествоКонечныйОстаток
	|ПОМЕСТИТЬ ДвиженияКИС
	|ИЗ
	|	&ТЗДвиженияКИС КАК ТЗДвиженияКИС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвиженияWMS.Период КАК Период,
	|	ДвиженияWMS.Номенклатура КАК Номенклатура,
	|	ДвиженияWMS.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ДвиженияWMS.КоличествоНачальныйОстаток КАК WMSНач,
	|	ДвиженияWMS.КоличествоПриход КАК WMSПрих,
	|	ДвиженияWMS.КоличествоРасход КАК WMSРасх,
	|	ДвиженияWMS.КоличествоКонечныйОстаток КАК WMSКон,
	|	0 КАК КИСНач,
	|	0 КАК КИСПрих,
	|	0 КАК КИСРасх,
	|	0 КАК КИСКон,
	|	ДвиженияWMS.ДокументТип КАК ДокументТип,
	|	ДвиженияWMS.Документ КАК Документ,
	|	ДвиженияWMS.КИСДокумент КАК КИСДокумент,
	|	ДвиженияWMS.ДокКоличествоНачальныйОстаток КАК ДокНач,
	|	ДвиженияWMS.ДокКоличествоПриход КАК ДокПриход,
	|	ДвиженияWMS.ДокКоличествоРасход КАК ДокРасход,
	|	ДвиженияWMS.ДокКоличествоКонечныйОстаток КАК ДокКон
	|ПОМЕСТИТЬ ПодготовкаДвижения
	|ИЗ
	|	ДвиженияWMS КАК ДвиженияWMS
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДвиженияКИС.Период,
	|	ДвиженияКИС.Номенклатура,
	|	ДвиженияКИС.ХарактеристикаНоменклатуры,
	|	0,
	|	0,
	|	0,
	|	0,
	|	ДвиженияКИС.КоличествоНачальныйОстаток,
	|	ДвиженияКИС.КоличествоПриход,
	|	ДвиженияКИС.КоличествоРасход,
	|	ДвиженияКИС.КоличествоКонечныйОстаток,
	|	ДвиженияКИС.ДокументТип,
	|	NULL,
	|	ДвиженияКИС.КИСДокумент,
	|	ДвиженияКИС.ДокКоличествоНачальныйОстаток,
	|	ДвиженияКИС.ДокКоличествоПриход,
	|	ДвиженияКИС.ДокКоличествоРасход,
	|	ДвиженияКИС.ДокКоличествоКонечныйОстаток
	|ИЗ
	|	ДвиженияКИС КАК ДвиженияКИС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодготовкаДвижения.Период КАК Период,
	|	ПодготовкаДвижения.Номенклатура КАК Номенклатура,
	|	ПодготовкаДвижения.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ПодготовкаДвижения.WMSНач КАК WMSНач,
	|	ПодготовкаДвижения.WMSПрих КАК WMSПрих,
	|	ПодготовкаДвижения.WMSРасх КАК WMSРасх,
	|	ПодготовкаДвижения.WMSКон КАК WMSКон,
	|	ПодготовкаДвижения.КИСНач КАК КИСНач,
	|	ПодготовкаДвижения.КИСПрих КАК КИСПрих,
	|	ПодготовкаДвижения.КИСРасх КАК КИСРасх,
	|	ПодготовкаДвижения.КИСКон КАК КИСКон,
	|	ПодготовкаДвижения.ДокументТип КАК ДокументТип,
	|	ПодготовкаДвижения.Документ КАК Документ,
	|	ПодготовкаДвижения.КИСДокумент КАК КИСДокумент,
	|	ПодготовкаДвижения.ДокНач КАК ДокНач,
	|	ПодготовкаДвижения.ДокПриход КАК ДокПриход,
	|	ПодготовкаДвижения.ДокРасход КАК ДокРасход,
	|	ПодготовкаДвижения.ДокКон КАК ДокКон,
	|	ВЫБОР
	|		КОГДА ПодготовкаДвижения.Период = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоИтог,
	|	ИСТИНА КАК Детализация
	|ИЗ
	|	ПодготовкаДвижения КАК ПодготовкаДвижения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СПНоменклатура
	|		ПО ПодготовкаДвижения.Номенклатура = СПНоменклатура.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК СПХарактеристикиНоменклатуры
	|		ПО ПодготовкаДвижения.ХарактеристикаНоменклатуры = СПХарактеристикиНоменклатуры.Ссылка
	|ГДЕ
	|	СПНоменклатура.БЗ_WMS_Дата = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И СПНоменклатура.Изготовитель <> &Основное
	|
	|УПОРЯДОЧИТЬ ПО
	|	СПНоменклатура.Наименование,
	|	СПХарактеристикиНоменклатуры.Наименование,
	|	ПодготовкаДвижения.Период,
	|	ПодготовкаДвижения.ДокументТип
	|ИТОГИ
	|	МАКСИМУМ(WMSНач),
	|	МАКСИМУМ(WMSПрих),
	|	МАКСИМУМ(WMSРасх),
	|	МАКСИМУМ(WMSКон),
	|	МАКСИМУМ(КИСНач),
	|	МАКСИМУМ(КИСПрих),
	|	МАКСИМУМ(КИСРасх),
	|	МАКСИМУМ(КИСКон),
	|	МАКСИМУМ(ЭтоИтог)
	|ПО
	|	Номенклатура,
	|	ХарактеристикаНоменклатуры";
	Запрос.УстановитьПараметр("Основное", Справочники.СтруктурныеЕдиницы.НайтиПоКоду("НФ-000014"));
	Запрос.УстановитьПараметр("ТЗДвиженияWMS", ТБДвиженияWMS);
	Запрос.УстановитьПараметр("ТЗДвиженияКИС", ТБДвиженияКИС);
	ВыборкаНоменклатура = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);    
	
	Макет = ПолучитьМакет("Движение");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");	
	ОбластьТовар = Макет.ПолучитьОбласть("Товар");
	ОбластьДокWMS = Макет.ПолучитьОбласть("ДокументWMS");
	ОбластьДокКИС = Макет.ПолучитьОбласть("ДокументКИС");
	Таб = Новый ТабличныйДокумент;	
	Таб.ТекущаяОбласть=Таб.Область(1, 1, 1, 1);	
	Таб.Вывести(ОбластьЗаголовок);
	Таб.ФиксацияСверху=3;
	Таб.АвтоМасштаб=Истина;
	Ном=0;
	Ном1=0;
	Ном2=0;
	ЦветФонаМинус = Новый Цвет(0,0,255);
	ЦветФонаПлюс = Новый Цвет(255,0,0);
	ЦветФонаНорм = Новый Цвет(255, 251, 240);
	ЦветТекстаНорм = Новый Цвет(137, 132, 119);
	ЦветТекстаРазница = Новый Цвет(255, 255, 0);
	ЦветТекстаДокМинус = Новый Цвет(128,128,255);
	ЦветТекстаДокПлюс = Новый Цвет(255,128,128);
	Пока ВыборкаНоменклатура.Следующий() Цикл
		ВыборкаДвижения=ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);		
		Пока ВыборкаДвижения.Следующий() Цикл
			Если ПараметрыОтчета.ТолькоРасхожденияОстатков И ВыборкаДвижения.WMSКон=ВыборкаДвижения.КисКон Тогда
				Продолжить;
			КонецЕсли;
			Если ПараметрыОтчета.ТолькоРасхожденияОстатков И ПараметрыОтчета.ИгнорироватьНеЗавершеннуюОтгрузку И
				((ВыборкаДвижения.WMSКон-ВыборкаДвижения.КисКон)+(ВыборкаДвижения.WMSРасх-ВыборкаДвижения.КисРасх))=0 И
				ВыборкаДвижения.WMSНач=ВыборкаДвижения.КисНач Тогда
				Продолжить;
			КонецЕсли;
			Ном=Ном+1;			
			ОбластьТовар.Параметры.Ном=Формат(Ном,"ЧГ=");
			ОбластьТовар.Параметры.Товар=ПредставлениеТоварХарактеристика(ВыборкаДвижения.Номенклатура,ВыборкаДвижения.ХарактеристикаНоменклатуры);
			ОбластьТовар.Параметры.ТоварСсылка=ВыборкаДвижения.Номенклатура;
			ЗаполнитьЗначенияСвойств(ОбластьТовар.Параметры,ВыборкаДвижения);
			ОбластьТовар.Параметры.РазницаНач=ФорматЧислаТовар(ВыборкаДвижения.WMSНач-ВыборкаДвижения.КисНач);
			ОбластьТовар.Параметры.РазницаПриход=ФорматЧислаТовар(ВыборкаДвижения.WMSПрих-ВыборкаДвижения.КисПрих);
			ОбластьТовар.Параметры.РазницаРасход=ФорматЧислаТовар(ВыборкаДвижения.WMSРасх-ВыборкаДвижения.КисРасх);
			ОбластьТовар.Параметры.РазницаКон=ФорматЧислаТовар(ВыборкаДвижения.WMSКон-ВыборкаДвижения.КисКон);
			ОбластьТовар.Область("РазницаНач").ЦветФона = ?(ВыборкаДвижения.WMSНач-ВыборкаДвижения.КисНач>0, ЦветФонаПлюс,?(ВыборкаДвижения.WMSНач-ВыборкаДвижения.КисНач<0, ЦветФонаМинус, ЦветФонаНорм));
			ОбластьТовар.Область("РазницаНач").ЦветТекста = ?(ВыборкаДвижения.WMSНач-ВыборкаДвижения.КисНач<>0, ЦветТекстаРазница, ЦветТекстаНорм);
			ОбластьТовар.Область("РазницаПриход").ЦветФона = ?(ВыборкаДвижения.WMSПрих-ВыборкаДвижения.КисПрих>0, ЦветФонаПлюс,?(ВыборкаДвижения.WMSПрих-ВыборкаДвижения.КисПрих<0, ЦветФонаМинус, ЦветФонаНорм));
			ОбластьТовар.Область("РазницаПриход").ЦветТекста = ?(ВыборкаДвижения.WMSПрих-ВыборкаДвижения.КисПрих<>0, ЦветТекстаРазница, ЦветТекстаНорм);
			ОбластьТовар.Область("РазницаРасход").ЦветФона = ?(ВыборкаДвижения.WMSРасх-ВыборкаДвижения.КисРасх>0, ЦветФонаПлюс,?(ВыборкаДвижения.WMSРасх-ВыборкаДвижения.КисРасх<0, ЦветФонаМинус, ЦветФонаНорм));
			ОбластьТовар.Область("РазницаРасход").ЦветТекста = ?(ВыборкаДвижения.WMSРасх-ВыборкаДвижения.КисРасх<>0, ЦветТекстаРазница, ЦветТекстаНорм);
			ОбластьТовар.Область("РазницаКон").ЦветФона = ?(ВыборкаДвижения.WMSКон-ВыборкаДвижения.КисКон>0, ЦветФонаПлюс,?(ВыборкаДвижения.WMSКон-ВыборкаДвижения.КисКон<0, ЦветФонаМинус, ЦветФонаНорм));
			ОбластьТовар.Область("РазницаКон").ЦветТекста = ?(ВыборкаДвижения.WMSКон-ВыборкаДвижения.КисКон<>0, ЦветТекстаРазница, ЦветТекстаНорм);				
			Таб.Вывести(ОбластьТовар);
			Если Не ПараметрыОтчета.ДетализацияПоДокументам Тогда
				Продолжить;
			КонецЕсли;
			ВыборкаДокументы=ВыборкаДвижения.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);		
			Ном1=0;
			Пока ВыборкаДокументы.Следующий() Цикл
				Если ВыборкаДокументы.ЭтоИтог Тогда Продолжить; КонецЕсли;
				Ном1=Ном1+1;			
				Если ВыборкаДокументы.ДокументТип=1 Тогда
					ЗаполнитьЗначенияСвойств(ОбластьДокКИС.Параметры,ВыборкаДокументы);
					ОбластьДокКИС.Параметры.Ном=Ном1;
					//Если ТипЗнч(ВыборкаДокументы.КИСДокумент)=Тип("ДокументСсылка.СборкаТоваров") Тогда
					//	ДокументТекст="Сборка "+ВыборкаДокументы.КИСДокумент.Номер+" ("+Формат(ВыборкаДокументы.КИСДокумент.Дата,"ДФ=dd.MM.yyyy")+"); ОВ "+Формат(Число(ВыборкаДокументы.КИСДокумент.ДокОснование.Номер),"ЧГ=")+" "+ВыборкаДокументы.КИСДокумент.ДокОснование.Комментарий;
					//Иначе
						ДокументТекст=ВыборкаДокументы.КИСДокумент;
					//КонецЕсли;
					ОбластьДокКИС.Параметры.Документ=ДокументТекст;
					ОбластьДокКИС.Параметры.ДокументСсылка=ВыборкаДокументы.КИСДокумент;				
					Таб.Вывести(ОбластьДокКИС);				
				Иначе
					ЗаполнитьЗначенияСвойств(ОбластьДокWMS.Параметры,ВыборкаДокументы);
					ОбластьДокWMS.Параметры.Ном=Ном1;
					ОбластьДокWMS.Параметры.Документ=СокрЛП(ВыборкаДокументы.Документ);
					Таб.Вывести(ОбластьДокWMS);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Новый ХранилищеЗначения(Таб, Новый СжатиеДанных), АдресРезультата);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли