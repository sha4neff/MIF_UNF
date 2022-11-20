
#Область ОбработчикиСобытийФормы

&НаСервере
// Функция возвращает табличный документ для печати ТН
Функция ПечатнаяФорма(МассивОбъектов, ПараметрыПечати, ОбъектыПечати) Экспорт

	ТабличныйДокумент			= Новый ТабличныйДокумент;
	Макет 						= РеквизитФормыВЗначение("Объект").ПолучитьМакет("ПФ_MXL_ТранспортнаяНакладная");
	ВывестиГоризонтРазделитель	= Ложь;
	
	Для каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если ВывестиГоризонтРазделитель Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ВывестиГоризонтРазделитель	= Истина;
		КонецЕсли;
		
		НомерСтрокиНачало 						= ТабличныйДокумент.ВысотаТаблицы + 1;
		ТабличныйДокумент.ИмяПараметровПечати 	= "ПАРАМЕТРЫ_ПЕЧАТИ_ПечатьТН_ТН";
		
		// :::Лицевая
		ОбластьМакета 				= Макет.ПолучитьОбласть("ЧастьПервая");
		ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ОбластьМакета 				= Макет.ПолучитьОбласть("ЧастьВторая");
		ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		// :::Оборотная
		ОбластьМакетаОборотная		= Макет.ПолучитьОбласть("ЧастьТретья");
		ОбластьМакетаОборотная.Параметры.Заполнить(ПараметрыПечати);
		ТабличныйДокумент.Вывести(ОбластьМакетаОборотная);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, ТабличныйДокумент.ВысотаТаблицы + 1, ОбъектыПечати, ТекущийДокумент);
		
		// :::Параметры макета
		ТабличныйДокумент.ПолеСверху = 0;
		ТабличныйДокумент.ПолеСлева  = 0;
		ТабличныйДокумент.ПолеСнизу  = 0;
		ТабличныйДокумент.ПолеСправа = 0;
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
	
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

&НаСервере
// Процедура обработчик события ПриСозданииНаСервере
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Документ") Тогда
		
		Объект.Документ = Параметры.Документ;
		
	КонецЕсли;
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("ЮрЛицо", Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо);
	КэшЗначений.Вставить("ФизЛицо", Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
	
	ВосстановитьНастройки(Ложь);
	
КонецПроцедуры //ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидГрузоотправителяПриИзменении(Элемент)
	
	Если ВидГрузоотправителя = КэшЗначений.ЮрЛицо Тогда
		
		ГрузоотправительФЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузоотправительЮЛ", "Доступность", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузоотправительФЛ", "Доступность", Ложь);
		
	Иначе
		
		ГрузоотправительЮЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузоотправительЮЛ", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузоотправительФЛ", "Доступность", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидГрузополучателяПриИзменении(Элемент)
	
	Если ВидГрузополучателя = КэшЗначений.ЮрЛицо Тогда
		
		ГрузополучательФЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузополучательЮЛ", "Доступность", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузополучательФЛ", "Доступность", Ложь);
		
	Иначе
		
		ГрузополучательЮЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузополучательЮЛ", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузополучательФЛ", "Доступность", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПеревозчикаПриИзменении(Элемент)
	
	Если ВидПеревозчика = КэшЗначений.ЮрЛицо Тогда
		
		ПеревозчикФЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПеревозчикЮЛ", "Доступность", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПеревозчикФЛ", "Доступность", Ложь);
		
	Иначе
		
		ПеревозчикЮЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПеревозчикЮЛ", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПеревозчикФЛ", "Доступность", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПринятияЗаказваПриИзменении(Элемент)
	
	ОбновитьИнформациюОПринятииЗаказа();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказПринялПриИзменении(Элемент)
	
	ОбновитьИнформациюОПринятииЗаказа();
	
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьПринявшегоЗаказПриИзменении(Элемент)
	
	ОбновитьИнформациюОПринятииЗаказа();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументПриИзменении(Элемент)
	
	Заполнить(Неопределено)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Процедура открывает форму для печати ТТН
//
Процедура ПечатьТН(Команда)
	
	НеЗаполняетсяИзФормы = "";
	
	ПараметрыПечати = Новый Структура();
	
	// ::: Раздел 0 (шапка и заголовки)
	ПараметрыПечати.Вставить("Пункт0_1", НомерЭкземпляра);
	ПараметрыПечати.Вставить("Пункт0_2", ДатаЗаявки);
	ПараметрыПечати.Вставить("Пункт0_3", НомерЗаявки);
	
	// ::: Раздел 1
	ПараметрыПечати.Вставить("Пункт1_1", ГрузоотправительФЛ);
	ПараметрыПечати.Вставить("Пункт1_2", ГрузоотправительЮЛ);
	
	// ::: Раздел 2
	ПараметрыПечати.Вставить("Пункт2_1", ГрузополучательФЛ);
	ПараметрыПечати.Вставить("Пункт2_2", ГрузополучательЮЛ);
	
	// ::: Раздел 3
	ПараметрыПечати.Вставить("Пункт3_1", НаименованиеГруза);
	ПараметрыПечати.Вставить("Пункт3_2", КоличествоМестМаркировка);
	ПараметрыПечати.Вставить("Пункт3_3", ГрузовыеМеста);
	ПараметрыПечати.Вставить("Пункт3_4", ИнформацияПоОпастнымВеществам);
	
	// ::: Раздел 4
	ПараметрыПечати.Вставить("Пункт4_1", ПрилагаемыеДокументы);
	ПараметрыПечати.Вставить("Пункт4_2", ПрилагаемыеСертификаты);
	
	// ::: Раздел 5
	ПараметрыПечати.Вставить("Пункт5_1", ПараметрыТранспортногоСредства);
	ПараметрыПечати.Вставить("Пункт5_2", НеобходимыеУказания);
	ПараметрыПечати.Вставить("Пункт5_3", Рекомендации);
	
	// ::: Раздел 6
	ПараметрыПечати.Вставить("Пункт6_1", АдресПогрузки);
	ПараметрыПечати.Вставить("Пункт6_2", СрокПодачиПодПогрузку);
	ПараметрыПечати.Вставить("Пункт6_3", ФактическоеПрибылПараграф6);
	ПараметрыПечати.Вставить("Пункт6_4", ФактическоеУбылПараграф6);
	ПараметрыПечати.Вставить("Пункт6_5", СостояниеГрузаПриПогрузке);
	ПараметрыПечати.Вставить("Пункт6_6", МассаГрузаПриЗагрузке);
	ПараметрыПечати.Вставить("Пункт6_7", КоличествоМестПриЗагрузке);
	ПараметрыПечати.Вставить("Пункт6_8", ПодписьГрузоотправителяПараграф6);
	ПараметрыПечати.Вставить("Пункт6_9", ПодписьВодителяПараграф6);
	
	// ::: Раздел 7
	ПараметрыПечати.Вставить("Пункт7_1", АдресВыгрузки);
	ПараметрыПечати.Вставить("Пункт7_2", СрокПодачиПодВыгрузку);
	ПараметрыПечати.Вставить("Пункт7_3", ФактическоеПрибылПараграф7);
	ПараметрыПечати.Вставить("Пункт7_4", ФактическоеУбылПараграф7);
	ПараметрыПечати.Вставить("Пункт7_5", СостояниеГрузаПриВыгрузке);
	ПараметрыПечати.Вставить("Пункт7_6", МассаГрузаПриВыгрузке);
	ПараметрыПечати.Вставить("Пункт7_7", КоличествоМестПриВыгрузке);
	ПараметрыПечати.Вставить("Пункт7_8", ПодписьГрузоотправителяПараграф7);
	ПараметрыПечати.Вставить("Пункт7_9", ПодписьВодителяПараграф7);
	
	// ::: Раздел 8
	ПараметрыПечати.Вставить("Пункт8_1", СрокУтратыГруза);
	ПараметрыПечати.Вставить("Пункт8_2", РазмерОплатыИПредСрокХранения);
	ПараметрыПечати.Вставить("Пункт8_3", СпособОпределенияМассыГруза);
	ПараметрыПечати.Вставить("Пункт8_4", ШтрафПоВинеПеревозчика);
	ПараметрыПечати.Вставить("Пункт8_5", ШтрафЗаПростой);
	
	// ::: Раздел 9
	ПараметрыПечати.Вставить("Пункт9_1", ДатаПринятияЗаказа);
	
	ТекстПункт9_2 = ?(ПустаяСтрока(ДолжностьПринявшегоЗаказ),
						ЗаказПринял,
						ЗаказПринял + " (" + ДолжностьПринявшегоЗаказ + ")");
	ПараметрыПечати.Вставить("Пункт9_2", ТекстПункт9_2);
	
	// ::: Раздел 10
	ПараметрыПечати.Вставить("Пункт10_1", ПеревозчикФЛ);
	ПараметрыПечати.Вставить("Пункт10_2", ПеревозчикЮЛ);
	ПараметрыПечати.Вставить("Пункт10_3", ОтветственныйЗаПеревозку);
	
	// ::: Раздел 11
	ПараметрыПечати.Вставить("Пункт11_1", ТипМарка);
	ПараметрыПечати.Вставить("Пункт11_2", РегистрационныеНомера);
	
	// ::: Раздел 12
	ПараметрыПечати.Вставить("Пункт12_1", ФактическоеСостояниеГруза);
	ПараметрыПечати.Вставить("Пункт12_2", ИзменениеУсловийПеревозки);
	ПараметрыПечати.Вставить("Пункт12_3", ФактическоеСостояниеТары);
	ПараметрыПечати.Вставить("Пункт12_4", ИзменениеУсловийПриВыгрузке);
	
	// ::: Раздел 13
	ПараметрыПечати.Вставить("Пункт13_1", ПрочиеУсловия);
	ПараметрыПечати.Вставить("Пункт13_2", РежимТрудаИОтдыхаВодителя);
	
	// ::: Раздел 14
	ПараметрыПечати.Вставить("Пункт14_1", ДатаФормаПереадресовки);
	ПараметрыПечати.Вставить("Пункт14_2", Переадресовщик);
	ПараметрыПечати.Вставить("Пункт14_3", НовыйПунктВыгрузки);
	ПараметрыПечати.Вставить("Пункт14_4", НовыйПолучательГруза);
	
	// ::: Раздел 15
	Если ЗначениеЗаполнено(СтоимостьУслугиВНациональнойВалюте) Тогда
		ПараметрыПечати.Вставить("Пункт15_1", "" + СтоимостьУслугиВНациональнойВалюте + " руб.; " + ПорядокРасчета);
	КонецЕсли;
	ПараметрыПечати.Вставить("Пункт15_2", РазмерПровознойПлаты);
	ПараметрыПечати.Вставить("Пункт15_3", РасходыДляПредъявленияГрузоотправителю);
	ПараметрыПечати.Вставить("Пункт15_4", УплатаТаможенныхСборовИПошлин);
	ПараметрыПечати.Вставить("Пункт15_5", ВыполнениеПогрузоРазгрузочныхРабот);
	ПараметрыПечати.Вставить("Пункт15_6", ГрузоотправительПункт15_6);
	
	// ::: Раздел 16
	ПараметрыПечати.Вставить("Пункт16_1", ГрузоотправительКраткоПункт16_1);
	ПараметрыПечати.Вставить("Пункт16_2", ДатаСоставленияГрузоотправитель);
	ПараметрыПечати.Вставить("Пункт16_3", ПеревозчикКраткоПункт16_3);
	ПараметрыПечати.Вставить("Пункт16_4", ДатаСоставленияПеревозчик);
	
	// ::: Раздел 17 (параграф не содержит параметров)
	
	ПараметрКоманды 			= Новый Массив;
	ПараметрКоманды.Добавить(Объект.Документ);
	ПараметрыВыполненияКоманды 	= Новый Структура;
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьТН", "ТН", ПараметрКоманды, ПараметрыВыполненияКоманды, ПараметрыПечати);
	
	// ::: Запомним значения реквизитов формы для документа
	СохранитьНастройки(Ложь);
	
КонецПроцедуры //ПечатьТНВыполнить()

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьПоДокументуОснованию();
	
КонецПроцедуры

&НаКлиенте
//  Процедура инициализирует сохранение значений полей формы
//  в хранилище общих настроек.
//
Процедура СохранитьЗначениеПолей(Команда)
	
	СохранитьНастройки();
	
КонецПроцедуры //СохранитьЗначениеПолей()

&НаКлиенте
//  Процедура инициализирует восстановление настройки для пользователя
//  и заполнение полей формы из восстановленной настройки
//
Процедура ВосстановитьЗначениеПолей(Команда)
	
	ВосстановитьНастройки();
	
КонецПроцедуры //ВосстановитьЗначениеПолей()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьГрузоотправителяПоРасходнойНакладной(ДокументОснование, МетаданныеДокумента)
	
	Если НЕ МетаданныеДокумента.Реквизиты.Найти("Грузоотправитель") = Неопределено 
		И ЗначениеЗаполнено(ДокументОснование.Грузоотправитель) Тогда
		
		ГрузоотправительДляПечати	= ДокументОснование.Грузоотправитель;
		
	ИначеЕсли НЕ МетаданныеДокумента.Реквизиты.Найти("Организация") = Неопределено 
		И ЗначениеЗаполнено(ДокументОснование.Организация) Тогда
		
		ГрузоотправительДляПечати	= ДокументОснование.Организация;
		
	ИначеЕсли ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиница) 
		И ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиница.Организация)  Тогда
		
		ГрузоотправительДляПечати	= ДокументОснование.СтруктурнаяЕдиница.Организация;
		
	Иначе
		
		ГрузоотправительДляПечати	= ДокументОснование.Организация;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГрузоотправительДляПечати) Тогда
		
		Если ТипЗнч(ГрузоотправительДляПечати) = Тип("СправочникСсылка.Контрагенты") Тогда
			
			ЭтоФизЛицо = (ГрузоотправительДляПечати.ВидКонтрагента = Перечисления.ВидыКонтрагентов.ИндивидуальныйПредприниматель)
							ИЛИ (ГрузоотправительДляПечати.ВидКонтрагента = Перечисления.ВидыКонтрагентов.ФизическоеЛицо);
				
		Иначе
			
			ЭтоФизЛицо = (ГрузоотправительДляПечати.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
			
		КонецЕсли;
		
		ВидГрузоотправителя			= ?(ЭтоФизЛицо, КэшЗначений.ФизЛицо, КэшЗначений.ЮрЛицо);
		СведенияОГрузоотправителе 	= УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ГрузоотправительДляПечати, ДокументОснование.Дата);
		
		ЭтаФорма[?(ЭтоФизЛицо, "ГрузоотправительФЛ", "ГрузоотправительЮЛ")]
		 			= УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОГрузоотправителе,
										?(ЭтоФизЛицо, "ПолноеНаименование, ИНН, ФактическийАдрес", 
														"ПолноеНаименование, ФактическийАдрес, Телефоны"));
		
		Если ТипЗнч(ГрузоотправительДляПечати) = Тип("СправочникСсылка.Организации")
			И ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиница.МОЛ) Тогда
			
			ОтветственныйГрузоотправитель = РегистрыСведений.ФИОФизЛиц.ФИОФизЛица(ДокументОснование.Дата, ДокументОснование.СтруктурнаяЕдиница.МОЛ);
			
		ИначеЕсли ТипЗнч(ГрузоотправительДляПечати) = Тип("СправочникСсылка.Контрагенты") 
			И НЕ ГрузоотправительДляПечати.Метаданные().Реквизиты.Найти("КонтактноеЛицо") = НЕОПРЕДЕЛЕНО Тогда
			
			ОтветственныйГрузоотправитель = ГрузоотправительДляПечати.КонтактноеЛицо.Наименование;
			
		КонецЕсли;
		
	Иначе
		
		ВидГрузоотправителя = КэшЗначений.ЮрЛицо;
		
	КонецЕсли;
	
	УправлениеДоступностьюГрузоотправителяНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьГрузополучателяПоРасходнойНакладной(ДокументОснование, МетаданныеДокумента)
	
	Если НЕ МетаданныеДокумента.Реквизиты.Найти("Грузополучатель") = Неопределено 
		И ЗначениеЗаполнено(ДокументОснование.Грузополучатель) Тогда
		
		ГрузополучательДляПечати	= ДокументОснование.Грузополучатель;
		
	Иначе
		
		ГрузополучательДляПечати	= ДокументОснование.Контрагент;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГрузополучательДляПечати) Тогда
		
		ЭтоФизЛицо					= (ГрузополучательДляПечати.ВидКонтрагента = Перечисления.ВидыКонтрагентов.ИндивидуальныйПредприниматель)
										ИЛИ (ГрузополучательДляПечати.ВидКонтрагента = Перечисления.ВидыКонтрагентов.ФизическоеЛицо);
		ВидГрузополучателя			= ?(ЭтоФизЛицо, КэшЗначений.ФизЛицо, КэшЗначений.ЮрЛицо);
		СведенияОГрузополучателе	= УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ГрузополучательДляПечати, ДокументОснование.Дата);
		
		ЭтаФорма[?(ЭтоФизЛицо, "ГрузополучательФЛ", "ГрузополучательЮЛ")]
			= УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОГрузополучателе,
										?(ЭтоФизЛицо, "ПолноеНаименование, ИНН, ФактическийАдрес", 
														"ПолноеНаименование, ФактическийАдрес, Телефоны"));
														
		Если НЕ ГрузополучательДляПечати.Метаданные().Реквизиты.Найти("КонтактноеЛицо") = НЕОПРЕДЕЛЕНО Тогда
			
			ОтветственныйГрузополучатель = ГрузополучательДляПечати.КонтактноеЛицо.Наименование;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеДоступностьюГрузополучателяНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПеревозчика(ДокументОснование, МетаданныеДокумента)
	
	ВидПеревозчика = КэшЗначений.ЮрЛицо;
	
	УправлениеДоступностьюПеревозчикаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностьюГрузоотправителяНаСервере()
	
	Если ВидГрузоотправителя = КэшЗначений.ЮрЛицо Тогда
		
		ГрузоотправительФЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузоотправительЮЛ", "Доступность", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузоотправительФЛ", "Доступность", Ложь);
		
	Иначе
		
		ГрузоотправительЮЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузоотправительЮЛ", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузоотправительФЛ", "Доступность", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностьюГрузополучателяНаСервере()
	
	Если ВидГрузополучателя = КэшЗначений.ЮрЛицо Тогда
		
		ГрузополучательФЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузополучательЮЛ", "Доступность", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузополучательФЛ", "Доступность", Ложь);
		
	Иначе
		
		ГрузополучательЮЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузополучательЮЛ", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрузополучательФЛ", "Доступность", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностьюПеревозчикаНаСервере()
	
	Если ВидПеревозчика = КэшЗначений.ЮрЛицо Тогда
		
		ПеревозчикФЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПеревозчикЮЛ", "Доступность", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПеревозчикФЛ", "Доступность", Ложь);
		
	Иначе
		
		ПеревозчикЮЛ = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПеревозчикЮЛ", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПеревозчикФЛ", "Доступность", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДокументуРасходнаяНакладная()
	
	ДокументОснование	= Объект.Документ;
	МетаданныеДокумента	= ДокументОснование.Метаданные();
	НомерЭкземпляра 	= 1;
	ДатаЗаявки			= ДокументОснование.Дата;
	
	// :::Грузоотправитель
	ЗаполнитьГрузоотправителяПоРасходнойНакладной(ДокументОснование, МетаданныеДокумента);
	
	// :::Грузополучатель
	ЗаполнитьГрузополучателяПоРасходнойНакладной(ДокументОснование, МетаданныеДокумента);
	
	// :::Перевозчик
	ЗаполнитьПеревозчика(ДокументОснование, МетаданныеДокумента);
	
	
КонецПроцедуры //ЗаполнитьПоДокументу()

&НаСервере
Процедура ЗаполнитьПоДокументуПеремещениеЗапасов()
	
	ДокументОснование	= Объект.Документ;
	МетаданныеДокумента	= ДокументОснование.Метаданные();
	НомерЭкземпляра 	= 1;
	ДатаЗаявки			= ДокументОснование.Дата;
	
	// :::Грузоотправитель
	ВидГрузоотправителя = КэшЗначений.ЮрЛицо;
	Если ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиница) 
		И ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиница.Организация) Тогда
		
		ГрузоотправительДляПечати	= ДокументОснование.СтруктурнаяЕдиница.Организация;
		ЭтоФизЛицо					= (ГрузоотправительДляПечати.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
		ВидГрузоотправителя			= ?(ЭтоФизЛицо, КэшЗначений.ФизЛицо, КэшЗначений.ЮрЛицо);
		СведенияОГрузоотправителе 	= УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ГрузоотправительДляПечати, ДокументОснование.Дата);
		ЭтаФорма[?(ЭтоФизЛицо, "ГрузоотправительФЛ", "ГрузоотправительЮЛ")]
			= УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОГрузоотправителе,
										?(ЭтоФизЛицо, "ПолноеНаименование, ИНН, ФактическийАдрес", 
														"ПолноеНаименование, ФактическийАдрес, Телефоны"));
		
		ОтветственныйГрузоотправитель = РегистрыСведений.ФИОФизЛиц.ФИОФизЛица(ДокументОснование.Дата, ДокументОснование.СтруктурнаяЕдиница.МОЛ);
		
	КонецЕсли;
	
	УправлениеДоступностьюГрузоотправителяНаСервере();
	
	// :::Грузополучатель
	ВидГрузополучателя = КэшЗначений.ЮрЛицо;
	Если ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиницаПолучатель) 
		И ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиницаПолучатель.Организация) Тогда
		
		ГрузополучательДляПечати	= ДокументОснование.СтруктурнаяЕдиницаПолучатель.Организация; 
		ЭтоФизЛицо					= (ГрузополучательДляПечати.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
		ВидГрузополучателя			= ?(ЭтоФизЛицо, КэшЗначений.ФизЛицо, КэшЗначений.ЮрЛицо);
		СведенияОГрузополучателе	= УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ГрузополучательДляПечати, ДокументОснование.Дата);
		ЭтаФорма[?(ЭтоФизЛицо, "ГрузополучательФЛ", "ГрузополучательЮЛ")]
			= УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОГрузополучателе,
										?(ЭтоФизЛицо, "ПолноеНаименование, ИНН, ФактическийАдрес", 
														"ПолноеНаименование, ФактическийАдрес, Телефоны"));
		
		ОтветственныйГрузополучатель = РегистрыСведений.ФИОФизЛиц.ФИОФизЛица(ДокументОснование.Дата, ДокументОснование.СтруктурнаяЕдиницаПолучатель.МОЛ);
		
	КонецЕсли;
	
	УправлениеДоступностьюГрузополучателяНаСервере();
	
	// :::Перевозчик
	ЗаполнитьПеревозчика(ДокументОснование, МетаданныеДокумента);
	
КонецПроцедуры //ЗаполнитьПоДокументуПеремещениеЗапасов()

&НаСервере
Процедура ЗаполнитьПоДокументуОтчетОПереработке()
	
	ДокументОснование	= Объект.Документ;
	МетаданныеДокумента	= ДокументОснование.Метаданные();
	НомерЭкземпляра 	= 1;
	ДатаЗаявки			= ДокументОснование.Дата;
	
	// :::Грузоотправитель
	ВидГрузоотправителя = КэшЗначений.ЮрЛицо;
	Если НЕ МетаданныеДокумента.Реквизиты.Найти("Грузоотправитель") = Неопределено 
		И ЗначениеЗаполнено(ДокументОснование.Грузоотправитель) Тогда
		
		ГрузоотправительДляПечати	= ДокументОснование.Грузоотправитель;
		
	ИначеЕсли ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиница) 
		И ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиница.Организация)  Тогда
		
		ГрузоотправительДляПечати	= ДокументОснование.СтруктурнаяЕдиница.Организация;
		
	Иначе
		
		ГрузоотправительДляПечати	= ДокументОснование.Организация;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГрузоотправительДляПечати) Тогда
	
		ЭтоФизЛицо					= (ГрузоотправительДляПечати.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
		ВидГрузоотправителя			= ?(ЭтоФизЛицо, КэшЗначений.ФизЛицо, КэшЗначений.ЮрЛицо);
		СведенияОГрузоотправителе 	= УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ГрузоотправительДляПечати, ДокументОснование.Дата);
		ЭтаФорма[?(ЭтоФизЛицо, "ГрузоотправительФЛ", "ГрузоотправительЮЛ")] 
			= УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОГрузоотправителе,
										?(ЭтоФизЛицо, "ПолноеНаименование, ИНН, ФактическийАдрес", 
														"ПолноеНаименование, ФактическийАдрес, Телефоны"));
														
														
		Если ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиница.МОЛ) Тогда
			
			ОтветственныйГрузоотправитель = РегистрыСведений.ФИОФизЛиц.ФИОФизЛица(ДокументОснование.Дата, ДокументОснование.СтруктурнаяЕдиница.МОЛ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеДоступностьюГрузоотправителяНаСервере();
	
	// :::Грузополучатель
	ВидГрузополучателя = КэшЗначений.ЮрЛицо;
	Если НЕ МетаданныеДокумента.Реквизиты.Найти("Грузополучатель") = Неопределено 
		И ЗначениеЗаполнено(ДокументОснование.Грузополучатель) Тогда
		
		ГрузополучательДляПечати	= ДокументОснование.Грузополучатель;
		
	Иначе
		
		ГрузополучательДляПечати	= ДокументОснование.Контрагент;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГрузополучательДляПечати) Тогда
		
		ЭтоФизЛицо					= (ГрузополучательДляПечати.ВидКонтрагента = Перечисления.ВидыКонтрагентов.ИндивидуальныйПредприниматель)
										ИЛИ (ГрузополучательДляПечати.ВидКонтрагента = Перечисления.ВидыКонтрагентов.ФизическоеЛицо);
		ВидГрузополучателя			= ?(ЭтоФизЛицо, КэшЗначений.ФизЛицо, КэшЗначений.ЮрЛицо);
		СведенияОГрузополучателе	= УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ГрузополучательДляПечати, ДокументОснование.Дата);
		ЭтаФорма[?(ЭтоФизЛицо, "ГрузополучательФЛ", "ГрузополучательЮЛ")]
			= УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОГрузополучателе,
										?(ЭтоФизЛицо, "ПолноеНаименование, ИНН, ФактическийАдрес", 
														"ПолноеНаименование, ФактическийАдрес, Телефоны"));
														
		Если НЕ ГрузополучательДляПечати.Метаданные().Реквизиты.Найти("КонтактноеЛицо") = НЕОПРЕДЕЛЕНО Тогда
			
			ОтветственныйГрузополучатель = ГрузополучательДляПечати.КонтактноеЛицо.Наименование;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеДоступностьюГрузополучателяНаСервере();
	
	// :::Перевозчик
	ЗаполнитьПеревозчика(ДокументОснование, МетаданныеДокумента);
	
КонецПроцедуры //ЗаполнитьПоДокументуОтчетОПереработке()

&НаСервере
Процедура ЗаполнитьПоДокументуОснованию()
	
	Если НЕ ЗначениеЗаполнено(Объект.Документ) Тогда
		
		ДатаЗаявки = ТекущаяДата();
		
		Возврат;
		
	ИначеЕсли ТипЗнч(Объект.Документ) = Тип("ДокументСсылка.РасходнаяНакладная") Тогда
		
		ЗаполнитьПоДокументуРасходнаяНакладная();
		
	ИначеЕсли ТипЗнч(Объект.Документ) = Тип("ДокументСсылка.ПеремещениеЗапасов") Тогда
		
		ЗаполнитьПоДокументуПеремещениеЗапасов();
		
	ИначеЕсли ТипЗнч(Объект.Документ) = Тип("ДокументСсылка.ОтчетОПереработке") Тогда
		
		ЗаполнитьПоДокументуОтчетОПереработке();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Собирает информационную строку о принятии заказа 
// по данным нескольких реквизитов формы
Процедура ОбновитьИнформациюОПринятииЗаказа()
	
	ИнформацияОПринятииЗаказа = "";
	
	Если ЗначениеЗаполнено(ДатаПринятияЗаказа) Тогда
		
		ИнформацияОПринятииЗаказа = НСтр("ru = 'Заказ от '") + Формат(ДатаПринятияЗаказа, "ДЛФ=DD");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗаказПринял) Тогда
		
		ИнформацияОПринятииЗаказа = ИнформацияОПринятииЗаказа + НСтр("ru = '; заказ принял(а) '") + ЗаказПринял;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДолжностьПринявшегоЗаказ) Тогда
		
		ИнформацияОПринятииЗаказа = ИнформацияОПринятииЗаказа + " (" + ДолжностьПринявшегоЗаказ + ")";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Восстанавливает настройки из хранилища общих настроек
//
Процедура ВосстановитьНастройки(Пользовательские = Истина)
	Перем СтруктураПолейФормы;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользовательские Тогда
		
		СтруктураПолейФормы = ХранилищеОбщихНастроек.Загрузить("Обработки.ПечатьТН",	"Пользовательские",			"Настройки печати");
		
	Иначе
		
		СтруктураПолейФормы = ХранилищеОбщихНастроек.Загрузить("Обработки.ПечатьТН",	СокрЛП(Объект.Документ),	"Настройки печати",		"Общие");
		
	КонецЕсли;
	
	Если СтруктураПолейФормы = Неопределено Тогда
		
		// Заполним повторно поля значениями из документа
		ЗаполнитьПоДокументуОснованию();
		
	Иначе
		
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураПолейФормы);
		
		Если НЕ ЗначениеЗаполнено(ВидГрузоотправителя) Тогда
			
			СтароеЗначениеВидГрузоотправителя = Неопределено;
			СтруктураПолейФормы.Свойство("ВидГрузоотправителя", СтароеЗначениеВидГрузоотправителя);
			
			ВидГрузоотправителя = ?(СтароеЗначениеВидГрузоотправителя = "Юр. лицо", КэшЗначений.ЮрЛицо, КэшЗначений.ФизЛицо);
			
		КонецЕсли;
		
		Если ВидГрузоотправителя = КэшЗначений.ФизЛицо 
			И ПустаяСтрока(ГрузоотправительФЛ) Тогда
			
			СтруктураПолейФормы.Свойство("Грузоотправитель", ГрузоотправительФЛ);
			
		КонецЕсли;
		
		Если ВидГрузоотправителя = КэшЗначений.ЮрЛицо 
			И ПустаяСтрока(ГрузоотправительЮЛ) Тогда
			
			СтруктураПолейФормы.Свойство("ГрузоотправительПродолжение", ГрузоотправительЮЛ);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ВидГрузополучателя) Тогда
			
			СтароеЗначениеВидГрузополучателя = Неопределено;
			СтруктураПолейФормы.Свойство("ВидГрузополучателя", СтароеЗначениеВидГрузополучателя);
			
			ВидГрузополучателя = ?(СтароеЗначениеВидГрузополучателя = "Юр. лицо", КэшЗначений.ЮрЛицо, КэшЗначений.ФизЛицо);
			
		КонецЕсли;
		
		Если ВидГрузополучателя = КэшЗначений.ФизЛицо
			И ПустаяСтрока(ГрузополучательФЛ) Тогда
			
			СтруктураПолейФормы.Свойство("Грузополучатель", ГрузополучательФЛ);
			
		КонецЕсли;
		
		Если ВидГрузополучателя = КэшЗначений.ЮрЛицо
			И ПустаяСтрока(ГрузополучательЮЛ) Тогда
			
			СтруктураПолейФормы.Свойство("ГрузополучательПродолжение", ГрузополучательЮЛ);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ВидПеревозчика) Тогда
			
			СтароеЗначениеВидПеревозчика = Неопределено;
			СтруктураПолейФормы.Свойство("ВидПеревозчика", СтароеЗначениеВидПеревозчика);
			
			ВидПеревозчика = ?(СтароеЗначениеВидПеревозчика = "Юр. лицо", КэшЗначений.ЮрЛицо, КэшЗначений.ФизЛицо);
			
		КонецЕсли;
		
		Если ВидПеревозчика = КэшЗначений.ФизЛицо
			И ПустаяСтрока(ПеревозчикФЛ) Тогда
			
			СтруктураПолейФормы.Свойство("Перевозчик", ПеревозчикФЛ);
			
		КонецЕсли;
		
		Если ВидПеревозчика = КэшЗначений.ЮрЛицо
			И ПустаяСтрока(ПеревозчикЮЛ) Тогда
			
			СтруктураПолейФормы.Свойство("ПеревозчикПродолжение", ПеревозчикЮЛ);
			
		КонецЕсли;
		
		УправлениеДоступностьюГрузоотправителяНаСервере();
		
		УправлениеДоступностьюГрузополучателяНаСервере();
		
		УправлениеДоступностьюПеревозчикаНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры // ВосстановитьНастройки()

&НаСервере
// Сохраняет настройки в хранилище общих настроек
//
//
Процедура СохранитьНастройки(Пользовательские = Истина)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураПолейФормы = СформироватьСтруктуруПолейФормыНаСервере();
	
	Если Пользовательские Тогда
		
		ХранилищеОбщихНастроек.Сохранить("Обработки.ПечатьТН",	"Пользовательские", 		СтруктураПолейФормы,	"Настройки печати");
		
	Иначе
		
		ХранилищеОбщихНастроек.Сохранить("Обработки.ПечатьТН",	СокрЛП(Объект.Документ),	СтруктураПолейФормы,	"Настройки печати",	"Общие");
		
	КонецЕсли;
	
КонецПроцедуры //СохранитьПользовательскийШаблон()

&НаСервере
// Формирует структуру заполненую значениями полей формы
//
//  Ключ структуры	- идентификатор поля;
//  Значение 		- значение поля;
//  
Функция СформироватьСтруктуруПолейФормыНаСервере()
	
	СтруктураПолейФормы = Новый Структура();
	
	// ::: Раздел 0 (Шапка и заголовки)
	СтруктураПолейФормы.Вставить("НомерЭкземпляра", 				НомерЭкземпляра);
	СтруктураПолейФормы.Вставить("ДатаЗаявки", 						ДатаЗаявки);
	СтруктураПолейФормы.Вставить("НомерЗаявки", 					НомерЗаявки);
	
	// ::: Раздел 1
	СтруктураПолейФормы.Вставить("ВидГрузоотправителя", 			ВидГрузоотправителя);
	СтруктураПолейФормы.Вставить("ГрузоотправительФЛ", 				ГрузоотправительФЛ);
	СтруктураПолейФормы.Вставить("ГрузоотправительЮЛ",				ГрузоотправительЮЛ);
	
	// ::: Раздел 2
	СтруктураПолейФормы.Вставить("ВидГрузополучателя", 				ВидГрузополучателя);
	СтруктураПолейФормы.Вставить("ГрузополучательФЛ", 				ГрузополучательФЛ);
	СтруктураПолейФормы.Вставить("ГрузополучательЮЛ",				ГрузополучательЮЛ);
	
	// ::: Раздел 3
	СтруктураПолейФормы.Вставить("НаименованиеГруза", 				НаименованиеГруза);
	СтруктураПолейФормы.Вставить("КоличествоМестМаркировка",		КоличествоМестМаркировка);
	СтруктураПолейФормы.Вставить("ГрузовыеМеста", 					ГрузовыеМеста);
	СтруктураПолейФормы.Вставить("ИнформацияПоОпастнымВеществам",	ИнформацияПоОпастнымВеществам);
	
	// ::: Раздел 4
	СтруктураПолейФормы.Вставить("ПрилагаемыеДокументы", 			ПрилагаемыеДокументы);
	СтруктураПолейФормы.Вставить("ПрилагаемыеСертификаты", 			ПрилагаемыеСертификаты);
	
	// ::: Раздел 5
	СтруктураПолейФормы.Вставить("ПараметрыТранспортногоСредства",	ПараметрыТранспортногоСредства);
	СтруктураПолейФормы.Вставить("НеобходимыеУказания", 			НеобходимыеУказания);
	СтруктураПолейФормы.Вставить("Рекомендации", 					Рекомендации);
	
	// ::: Раздел 6
	СтруктураПолейФормы.Вставить("АдресПогрузки", 					АдресПогрузки);
	СтруктураПолейФормы.Вставить("СрокПодачиПодПогрузку", 			СрокПодачиПодПогрузку);
	СтруктураПолейФормы.Вставить("ФактическоеПрибылПараграф6",		ФактическоеПрибылПараграф6);
	СтруктураПолейФормы.Вставить("ФактическоеУбылПараграф6",		ФактическоеУбылПараграф6);
	СтруктураПолейФормы.Вставить("СостояниеГрузаПриПогрузке",		СостояниеГрузаПриПогрузке);
	СтруктураПолейФормы.Вставить("МассаГрузаПриЗагрузке",			МассаГрузаПриЗагрузке);
	СтруктураПолейФормы.Вставить("КоличествоМестПриЗагрузке", 		КоличествоМестПриЗагрузке);
	СтруктураПолейФормы.Вставить("ПодписьГрузоотправителяПараграф6",ПодписьГрузоотправителяПараграф6);
	СтруктураПолейФормы.Вставить("ПодписьВодителяПараграф6", 		ПодписьВодителяПараграф6);
	
	// ::: Раздел 7
	СтруктураПолейФормы.Вставить("АдресВыгрузки", 					АдресВыгрузки);
	СтруктураПолейФормы.Вставить("СрокПодачиПодВыгрузку", 			СрокПодачиПодВыгрузку);
	СтруктураПолейФормы.Вставить("ФактическоеПрибылПараграф7", 		ФактическоеПрибылПараграф7);
	СтруктураПолейФормы.Вставить("ФактическоеУбылПараграф7", 		ФактическоеУбылПараграф7);
	СтруктураПолейФормы.Вставить("СостояниеГрузаПриПогрузке",		СостояниеГрузаПриВыгрузке);
	СтруктураПолейФормы.Вставить("МассаГрузаПриВыгрузке",			МассаГрузаПриВыгрузке);
	СтруктураПолейФормы.Вставить("КоличествоМестПриВыгрузке", 		КоличествоМестПриВыгрузке);
	СтруктураПолейФормы.Вставить("ПодписьГрузоотправителяПараграф7",ПодписьГрузоотправителяПараграф7);
	СтруктураПолейФормы.Вставить("ПодписьВодителяПараграф7", 		ПодписьВодителяПараграф7);
	
	// ::: Раздел 8
	СтруктураПолейФормы.Вставить("СрокУтратыГруза", 				СрокУтратыГруза);
	СтруктураПолейФормы.Вставить("РазмерОплатыИПредСрокХранения",	РазмерОплатыИПредСрокХранения);
	СтруктураПолейФормы.Вставить("СпособОпределенияМассыГруза",		СпособОпределенияМассыГруза);
	СтруктураПолейФормы.Вставить("ШтрафПоВинеПеревозчика", 			ШтрафПоВинеПеревозчика);
	СтруктураПолейФормы.Вставить("ШтрафЗаПростой", 					ШтрафЗаПростой);
	
	// ::: Раздел 9
	СтруктураПолейФормы.Вставить("ДатаПринятияЗаказа", 				ДатаПринятияЗаказа);
	СтруктураПолейФормы.Вставить("ЗаказПринял", 					ЗаказПринял);
	СтруктураПолейФормы.Вставить("ДолжностьПринявшегоЗаказ",		ДолжностьПринявшегоЗаказ);
	
	// ::: Раздел 10
	СтруктураПолейФормы.Вставить("ВидПеревозчика", 					ВидПеревозчика);
	СтруктураПолейФормы.Вставить("ПеревозчикФЛ", 					ПеревозчикФЛ);
	СтруктураПолейФормы.Вставить("ПеревозчикЮЛ",					ПеревозчикЮЛ);
	СтруктураПолейФормы.Вставить("ОтветственныйЗаПеревозку",		ОтветственныйЗаПеревозку);
	
	// ::: Раздел 11
	СтруктураПолейФормы.Вставить("ТипМарка", 						ТипМарка);
	СтруктураПолейФормы.Вставить("РегистрационныеНомера",			РегистрационныеНомера);
	
	// ::: Раздел 12
	СтруктураПолейФормы.Вставить("ФактическоеСостояниеГруза",		ФактическоеСостояниеГруза);
	СтруктураПолейФормы.Вставить("ИзменениеУсловийПеревозки",		ИзменениеУсловийПеревозки);
	СтруктураПолейФормы.Вставить("ФактическоеСостояниеТары",		ФактическоеСостояниеТары);
	СтруктураПолейФормы.Вставить("ИзменениеУсловийПриВыгрузке",		ИзменениеУсловийПриВыгрузке);
	
	// ::: Раздел 13
	СтруктураПолейФормы.Вставить("ПрочиеУсловия", 					ПрочиеУсловия);
	СтруктураПолейФормы.Вставить("РежимТрудаИОтдыхаВодителя",		РежимТрудаИОтдыхаВодителя);
	
	// ::: Раздел 14
	СтруктураПолейФормы.Вставить("ДатаФормаПереадресовки",			ДатаФормаПереадресовки);
	СтруктураПолейФормы.Вставить("Переадресовщик", 					Переадресовщик);
	СтруктураПолейФормы.Вставить("НовыйПунктВыгрузки", 				НовыйПунктВыгрузки);
	СтруктураПолейФормы.Вставить("НовыйПолучательГруза", 			НовыйПолучательГруза);
	
	// ::: Раздел 15
	СтруктураПолейФормы.Вставить("СтоимостьУслугиВНациональнойВалюте", СтоимостьУслугиВНациональнойВалюте);
	СтруктураПолейФормы.Вставить("ПорядокРасчета", 					ПорядокРасчета);
	СтруктураПолейФормы.Вставить("РазмерПровознойПлаты", 			РазмерПровознойПлаты);
	СтруктураПолейФормы.Вставить("РасходыДляПредъявленияГрузоотправителю", РасходыДляПредъявленияГрузоотправителю);
	СтруктураПолейФормы.Вставить("УплатаТаможенныхСборовИПошлин",	УплатаТаможенныхСборовИПошлин);
	СтруктураПолейФормы.Вставить("ВыполнениеПогрузоРазгрузочныхРабот", ВыполнениеПогрузоРазгрузочныхРабот);
	СтруктураПолейФормы.Вставить("ГрузоотправительПункт15_6", 		ГрузоотправительПункт15_6);
	
	// ::: Раздел 16 (раздел отсутствует)
	СтруктураПолейФормы.Вставить("ГрузоотправительКраткоПункт16_1",	ГрузоотправительКраткоПункт16_1);
	СтруктураПолейФормы.Вставить("ДатаСоставленияГрузоотправитель",	ДатаСоставленияГрузоотправитель);
	СтруктураПолейФормы.Вставить("ПеревозчикКраткоПункт16_3", 		ПеревозчикКраткоПункт16_3);
	СтруктураПолейФормы.Вставить("ДатаСоставленияПеревозчик", 		ДатаСоставленияПеревозчик);
	
	// ::: Раздел 17 (раздел отсутствует)
	
	Возврат СтруктураПолейФормы;
	
КонецФункции  // СформироватьСтруктуруПолейФормыНаСервере()

#КонецОбласти
