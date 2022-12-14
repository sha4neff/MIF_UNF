#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища) Экспорт
	
	ПараметрыОтчета.СписокСформированныхЛистов.Очистить();
	
	ПараметрыОтчета.НачалоПериода	= НачалоДня(ПараметрыОтчета.НачалоПериода);
	ПараметрыОтчета.КонецПериода	= КонецДня(ПараметрыОтчета.КонецПериода);
	
	// ПОДГОТОВКА ОТЧЕТА ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	ПодготовитьДанныеОтчета(ПараметрыОтчета);
	
	// ПОСТРОЕНИЕ ОТЧЕТА
	
	СформироватьТитульныйЛист(ПараметрыОтчета);
	
	СформироватьТаблицуДоходы(ПараметрыОтчета);
	
	ПоместитьВоВременноеХранилище(ПараметрыОтчета.СписокСформированныхЛистов, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодготовитьДанныеОтчета(ПараметрыОтчета)
	
	НомераТаблиц	= Новый Структура;
	
	Запрос	= Новый Запрос;
	Запрос.УстановитьПараметр("Организация",	ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("Патент",			ПараметрыОтчета.Патент);
	Запрос.УстановитьПараметр("НачалоПериода",	ПараметрыОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",	ПараметрыОтчета.КонецПериода);
	Запрос.УстановитьПараметр("ПустаяДата",		Дата("00010101"));
	
	Запрос.Текст	= ТекстЗапросаТитульныйЛист(ПараметрыОтчета, НомераТаблиц)
					+ ТекстЗапросаКнигаУчетаДоходовПатент(ПараметрыОтчета, НомераТаблиц);
		
	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		
		Если Результат[НомерТаблицы.Значение] <> Неопределено Тогда
			ПараметрыОтчета.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение]);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТекстЗапросаТитульныйЛист(ПараметрыОтчета, НомераТаблиц)
	
	НомераТаблиц.Вставить("БанковскиеСчета",	НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	БанковскиеСчета.НомерСчета КАК НомерСчета,
	|	БанковскиеСчета.Банк.Наименование КАК НаименованиеБанка
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Владелец = &Организация
	|	И (БанковскиеСчета.ДатаОткрытия = &ПустаяДата ИЛИ БанковскиеСчета.ДатаОткрытия <= &КонецПериода)
	|	И (БанковскиеСчета.ДатаЗакрытия = &ПустаяДата ИЛИ БанковскиеСчета.ДатаЗакрытия >= &НачалоПериода)";
	
	Возврат ТекстЗапроса + УправлениеНебольшойФирмойСервер.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаКнигаУчетаДоходовПатент(ПараметрыОтчета, НомераТаблиц)
	
	НомераТаблиц.Вставить("КнигаУчетаДоходовПатент",	НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КнигаУчетаДоходовПатент.Регистратор КАК Регистратор,
	|	КнигаУчетаДоходовПатент.РеквизитыПервичногоДокумента КАК РеквизитыПервичногоДокумента,
	|	КнигаУчетаДоходовПатент.Содержание КАК Содержание,
	|	КнигаУчетаДоходовПатент.Графа4 КАК Графа4
	|ИЗ
	|	РегистрНакопления.КнигаУчетаДоходовПатент КАК КнигаУчетаДоходовПатент
	|ГДЕ
	|	КнигаУчетаДоходовПатент.Организация = &Организация
	|	И КнигаУчетаДоходовПатент.Патент = &Патент
	|	И КнигаУчетаДоходовПатент.Активность
	|	И КнигаУчетаДоходовПатент.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НЕ КнигаУчетаДоходовПатент.Графа4 = 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	КнигаУчетаДоходовПатент.Период,
	|	КнигаУчетаДоходовПатент.Регистратор,
	|	КнигаУчетаДоходовПатент.НомерСтроки
	|ИТОГИ
	|	СУММА(Графа4)
	|ПО
	|	ОБЩИЕ";
	
	Возврат ТекстЗапроса + УправлениеНебольшойФирмойСервер.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Процедура СформироватьТитульныйЛист(ПараметрыОтчета)
	
	СписокПоказателей = Новый СписокЗначений;
	СписокПоказателей.Добавить("", "ФИО");
	СписокПоказателей.Добавить("", "АдрПрописки");
	СписокПоказателей.Добавить("", "ОКПО");
	СписокПоказателей.Добавить("", "ОКАТО");
	СписокПоказателей.Добавить("", "ИННФЛ");
	
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
		ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода, СписокПоказателей);
		
	ТабличныйДокумент	= Новый ТабличныйДокумент;
	ТабличныйДокумент.Автомасштаб			= Истина;
	ТабличныйДокумент.ЧерноБелаяПечать		= Истина;
	ТабличныйДокумент.ТолькоПросмотр		= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_КнигаУчетаДоходовИРасходов_ТитульныйЛист";
	
	Если ПараметрыОтчета.КонецПериода < '20130101' Тогда
		Макет	= ПолучитьМакет("ТитульныйЛист_154н");
	Иначе
		Макет	= ПолучитьМакет("ТитульныйЛист_патент");
	КонецЕсли;
	
	Макет.Параметры.НаПериод	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'на %1 год'"),
		Формат(Год(ПараметрыОтчета.КонецПериода), "ЧГ="));
		
	Макет.Параметры.ФИО			= СведенияОбОрганизации.ФИО;
	Макет.Параметры.АдрПрописки	= РегламентированнаяОтчетностьКлиентСервер.ПредставлениеАдресаВФормате9Запятых(СведенияОбОрганизации.АдрПрописки);
	Макет.Параметры.ОКПО		= СведенияОбОрганизации.ОКПО;
	Макет.Параметры.ОКАТО		= СведенияОбОрганизации.ОКАТО;
		
	Счета = "";
	Выборка	= ПараметрыОтчета.БанковскиеСчета.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Счета	= Счета + ?(ПустаяСтрока(Счета), "", ", ")
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '№ %1 в %2'"), СокрЛП(Выборка.НомерСчета), СокрЛП(Выборка.НаименованиеБанка));
		
	КонецЦикла;
	Макет.Параметры.Счета	= Счета;
	
	Макет.Параметры.СрокПатента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'с %1 г. по %2 г.'"),
		Формат(ПараметрыОтчета.НачалоПериода, "ДФ='дд ММММ гггг'"),
		Формат(ПараметрыОтчета.КонецПериода, "ДФ='дд ММММ гггг'"));
	
	ТабличныйДокумент.Вывести(Макет);
	
	ИНН = СведенияОбОрганизации.ИННФЛ;
	
	Если СтрДлина(ИНН) <> 12 Тогда
		// Налогоплательщик - юр. лицо		
		ИНН = "00" + ИНН;		
	КонецЕсли;
	
	Ном = 1;
	Пока Ном > 0 Цикл
		ИмяОбластиИНН = "ПрИНН";
		Если НЕ(Ном > 12) Тогда
			ТабличныйДокумент.Область(ИмяОбластиИНН + Ном).Текст = ?(Число(ИНН) > 0, Сред(ИНН, Ном, 1), ""); 
			
			Ном = Ном + 1;
			Продолжить;
		КонецЕсли;
		Ном = 0;
	КонецЦикла;
		
	ПараметрыОтчета.СписокСформированныхЛистов.Добавить(ТабличныйДокумент, "Титульный лист");
	
КонецПроцедуры


Процедура СформироватьТаблицуДоходы(ПараметрыОтчета)
	
	ТабличныйДокумент	= Новый ТабличныйДокумент;
	ТабличныйДокумент.Автомасштаб			= Истина;
	ТабличныйДокумент.ЧерноБелаяПечать		= Истина;
	ТабличныйДокумент.ТолькоПросмотр		= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_КнигаУчетаДоходовПатент_ТаблицаДоходы";
	
	Если ПараметрыОтчета.КонецПериода < '20130101' Тогда
		Макет	= ПолучитьМакет("Раздел1_154н");
	Иначе
		Макет	= ПолучитьМакет("Раздел1_патент");
	КонецЕсли;
	
	ОбластьШапка	= Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока	=  Макет.ПолучитьОбласть("Строка");
	ОбластьИтого	= Макет.ПолучитьОбласть("Итого");
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
	ВыборкаОбщие	= ПараметрыОтчета.КнигаУчетаДоходовПатент.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ОБЩИЕ");
	Если ВыборкаОбщие.Следующий() Тогда
		
		НПП = 0;
		
		Выборка	= ВыборкаОбщие.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НПП = НПП + 1;
			
			ОбластьСтрока.Параметры.НомерПП = НПП;
			ОбластьСтрока.Параметры.Заполнить(Выборка);
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			
		КонецЦикла;
		
		ОбластьИтого.Параметры.Заполнить(ВыборкаОбщие);
		ТабличныйДокумент.Вывести(ОбластьИтого);
		
	КонецЕсли;
	
	ТабличныйДокумент.ПовторятьПриПечатиСтроки	= ТабличныйДокумент.Область(6, , 6, );
	
	ПараметрыОтчета.СписокСформированныхЛистов.Добавить(ТабличныйДокумент, "Доходы");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
