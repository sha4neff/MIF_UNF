
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);
	
	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СписокМодель = Элементы.Модель.СписокВыбора;
	СписокМодель.Добавить("CipherLab 80xx");
	СписокМодель.Добавить("CipherLab 82xx");
	СписокМодель.Добавить("CipherLab 83xx");
	СписокМодель.Добавить("CipherLab 84xx");           
	СписокМодель.Добавить("CipherLab 85xx");
	
	СписокПорт = Элементы.Порт.СписокВыбора;
	Для Индекс = 1 По 256 Цикл
		СписокПорт.Добавить(Индекс, "COM" + СокрЛП(Индекс));
	КонецЦикла;
	
	СписокТипСвязи =  Элементы.ТипСвязи.СписокВыбора;
	СписокТипСвязи.Добавить(0, "ИК-подставка");
	СписокТипСвязи.Добавить(1, "Кабель");
	СписокТипСвязи.Добавить(2, "Bluetooth SPP");
	
	СписокСкорость = Элементы.Скорость.СписокВыбора;
	СписокСкорость.Добавить(1, "115200");
	СписокСкорость.Добавить(2, "57600");
	СписокСкорость.Добавить(3, "38400");
	СписокСкорость.Добавить(4, "19200");
	СписокСкорость.Добавить(5, "9600");
	
	СписокИсточникЗагрузки = Элементы.ИсточникЗагрузки.СписокВыбора;
	СписокИсточникЗагрузки.Добавить("Документ", НСтр("ru='Документ терминала сбора данных'"));
	СписокИсточникЗагрузки.Добавить("База",     НСтр("ru='База терминала сбора данных'"));
	
	времПорт              = Неопределено;
	времСкорость          = Неопределено;
	времТипСвязи          = Неопределено;
	времНомерБазы         = Неопределено;
	времНомерДокумента    = Неопределено;
	времОчищатьДокумент   = Неопределено;
	времФорматБазы        = Неопределено;
	времФорматДокумента   = Неопределено;
	времМодель            = Неопределено;
	времИсточникЗагрузки  = Неопределено;
	
	Параметры.ПараметрыОборудования.Свойство("Порт"                    , времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость"                , времСкорость);
	Параметры.ПараметрыОборудования.Свойство("ТипСвязи"                , времТипСвязи);
	Параметры.ПараметрыОборудования.Свойство("НомерБазы"               , времНомерБазы);
	Параметры.ПараметрыОборудования.Свойство("НомерДокумента"          , времНомерДокумента);
	Параметры.ПараметрыОборудования.Свойство("ОчищатьДокумент"         , времОчищатьДокумент);
	Параметры.ПараметрыОборудования.Свойство("ФорматБазы"              , времФорматБазы);
	Параметры.ПараметрыОборудования.Свойство("ФорматДокумента"         , времФорматДокумента);
	Параметры.ПараметрыОборудования.Свойство("Модель"                  , времМодель);
	Параметры.ПараметрыОборудования.Свойство("ИсточникЗагрузки"        , времИсточникЗагрузки);
	
	Порт             = ?(времПорт             = Неопределено,          1, времПорт);
	Скорость         = ?(времСкорость         = Неопределено,          1, времСкорость);
	ТипСвязи         = ?(времТипСвязи         = Неопределено,          0, времТипСвязи);
	НомерБазы        = ?(времНомерБазы        = Неопределено,          1, времНомерБазы);
	НомерДокумента   = ?(времНомерДокумента   = Неопределено,          1, времНомерДокумента);
	ОчищатьДокумент  = ?(времОчищатьДокумент  = Неопределено,       Ложь, времОчищатьДокумент);
	ИсточникЗагрузки = ?(времИсточникЗагрузки = Неопределено, "Документ", времИсточникЗагрузки);
	
	Если времФорматБазы <> Неопределено Тогда
		Для Каждого СтрокаБазы Из времФорматБазы Цикл
			СтрокаТаблицы = ФорматБазы.Добавить();
			СтрокаТаблицы.НомерПоля    = СтрокаБазы.НомерПоля;
			СтрокаТаблицы.Наименование = СтрокаБазы.Наименование;
		КонецЦикла;
	КонецЕсли;

	Если времФорматДокумента <> Неопределено Тогда
		Для Каждого СтрокаДокумента Из времФорматДокумента Цикл
			СтрокаТаблицы = ФорматДокумента.Добавить();
			СтрокаТаблицы.НомерПоля    = СтрокаДокумента.НомерПоля;
			СтрокаТаблицы.Наименование = СтрокаДокумента.Наименование;
		КонецЦикла;
	КонецЕсли;

	Модель = ?(времМодель = Неопределено,  Элементы.Модель.СписокВыбора[0], времМодель);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	
	Если ФорматБазы.Количество() = 0 Тогда
		ЗаполнитьФорматБазыПоУмолчаниюНаСервере();
	КонецЕсли;
	Если ФорматДокумента.Количество() = 0 Тогда
		ЗаполнитьФорматДокументаПоУмолчаниюНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("Порт"             , Порт);
	НовыеЗначениеПараметров.Вставить("Скорость"         , Скорость);
	НовыеЗначениеПараметров.Вставить("ТипСвязи"         , ТипСвязи);
	НовыеЗначениеПараметров.Вставить("НомерБазы"        , НомерБазы);
	НовыеЗначениеПараметров.Вставить("НомерДокумента"   , НомерДокумента);
	НовыеЗначениеПараметров.Вставить("ОчищатьДокумент"  , ОчищатьДокумент);
	НовыеЗначениеПараметров.Вставить("Модель"           , Модель);
	НовыеЗначениеПараметров.Вставить("ИсточникЗагрузки" , ИсточникЗагрузки);
	
	времФорматБазы = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматБазы Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматБазы.Добавить(НоваяСтрока);
	КонецЦикла;
	НовыеЗначениеПараметров.Вставить("ФорматБазы", времФорматБазы);

	времФорматДокумента = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматДокумента Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматДокумента.Добавить(НоваяСтрока);
	КонецЦикла;
	НовыеЗначениеПараметров.Вставить("ФорматДокумента", времФорматДокумента);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверИзАрхиваПриЗавершении(Результат) Экспорт 
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.'")); 
	ОбновитьИнформациюОДрайвере();
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайверИзДистрибутиваПриЗавершении(Результат, Параметры) Экспорт 
	
	Если Результат Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.'")); 
		ОбновитьИнформациюОДрайвере();
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='При установке драйвера из дистрибутива произошла ошибка.'")); 
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	ОчиститьСообщения();
	ОповещенияДрайверИзДистрибутиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзДистрибутиваПриЗавершении", ЭтотОбъект);
	ОповещенияДрайверИзАрхиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзАрхиваПриЗавершении", ЭтотОбъект);
	МенеджерОборудованияКлиент.УстановитьДрайвер(ДрайверОборудования, ОповещенияДрайверИзДистрибутиваПриЗавершении, ОповещенияДрайверИзАрхиваПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	РезультатТеста = Неопределено;
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"                    , Порт);
	времПараметрыУстройства.Вставить("Скорость"                , Скорость);
	времПараметрыУстройства.Вставить("ТипСвязи"                , ТипСвязи);
	времПараметрыУстройства.Вставить("НомерБазы"               , НомерБазы);
	времПараметрыУстройства.Вставить("НомерДокумента"          , НомерДокумента);
	времПараметрыУстройства.Вставить("ОчищатьДокумент"         , ОчищатьДокумент);
	времПараметрыУстройства.Вставить("Модель"                  , Модель);
	времПараметрыУстройства.Вставить("ИсточникЗагрузки"        , ИсточникЗагрузки);

	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ТестУстройства",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства);

	Если Результат Тогда
			ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе
		ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
		                           И ВыходныеПараметры.Количество() >= 2,
		                           НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
		                           "");

		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"                    , Порт);
	времПараметрыУстройства.Вставить("Скорость"                , Скорость);
	времПараметрыУстройства.Вставить("ТипСвязи"                , ТипСвязи);
	времПараметрыУстройства.Вставить("НомерБазы"               , НомерБазы);
	времПараметрыУстройства.Вставить("НомерДокумента"          , НомерДокумента);
	времПараметрыУстройства.Вставить("ОчищатьДокумент"         , ОчищатьДокумент);
	времПараметрыУстройства.Вставить("Модель"                  , Модель);
	времПараметрыУстройства.Вставить("ИсточникЗагрузки"        , ИсточникЗагрузки);
	
	времФорматБазы = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматБазы Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматБазы.Добавить(НоваяСтрока);
	КонецЦикла;
	времПараметрыУстройства.Вставить("ФорматБазы", времФорматБазы);

	времФорматДокумента = Новый Массив(); 
	Для Каждого СтрокаТаблицы Из ФорматДокумента Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматДокумента.Добавить(НоваяСтрока);
	КонецЦикла;
	времПараметрыУстройства.Вставить("ФорматДокумента", времФорматДокумента);

	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		Драйвер = ВыходныеПараметры[2];
		Версия  = НСтр("ru='Не определена'");
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);
	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен'"));

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФорматБазыПоУмолчанию(Команда)
	ЗаполнитьФорматБазыПоУмолчаниюНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФорматДокументаПоУмолчанию(Команда)
	ЗаполнитьФорматДокументаПоУмолчаниюНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФорматБазыПоУмолчаниюНаСервере()
	ФорматБазы.Очистить();
	НоваяСтрока = ФорматБазы.Добавить();
	НоваяСтрока.НомерПоля 		= 1;
	НоваяСтрока.Наименование 	= Элементы.ФорматБазыНаименование.СписокВыбора[0];
	НоваяСтрока = ФорматБазы.Добавить();
	НоваяСтрока.НомерПоля 		= 2;
	НоваяСтрока.Наименование 	= Элементы.ФорматБазыНаименование.СписокВыбора[1];
	НоваяСтрока = ФорматБазы.Добавить();
	НоваяСтрока.НомерПоля 		= 3;
	НоваяСтрока.Наименование 	= Элементы.ФорматБазыНаименование.СписокВыбора[6];
	НоваяСтрока = ФорматБазы.Добавить();
	НоваяСтрока.НомерПоля 		= 4;
	НоваяСтрока.Наименование 	= Элементы.ФорматБазыНаименование.СписокВыбора[7];
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФорматДокументаПоУмолчаниюНаСервере()
	ФорматДокумента.Очистить();
	НоваяСтрока = ФорматДокумента.Добавить();
	НоваяСтрока.НомерПоля 		= 1;
	НоваяСтрока.Наименование 	= Элементы.ФорматДокументаНаименование.СписокВыбора[0];
	НоваяСтрока = ФорматДокумента.Добавить();
	НоваяСтрока.НомерПоля 		= 2;
	НоваяСтрока.Наименование 	= Элементы.ФорматДокументаНаименование.СписокВыбора[7];
КонецПроцедуры

#КонецОбласти