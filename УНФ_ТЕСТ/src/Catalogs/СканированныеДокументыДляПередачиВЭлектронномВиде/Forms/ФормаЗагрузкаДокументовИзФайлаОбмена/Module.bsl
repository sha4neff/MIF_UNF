&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторФормыВладельца = Параметры.ИдентификаторФормыВладельца;
	
	//список выбора вида документа
	СписокВыбораВидДокумента = Элементы.ВидДокумента.СписокВыбора;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Виды = КонтекстЭДОСервер.ВидыПредставляемыхДокументов();
	
	Для каждого Вид Из Виды Цикл
		СписокВыбораВидДокумента.Добавить(Вид);
	КонецЦикла; 
	СписокВыбораВидДокумента.Добавить(Перечисления.ВидыПредставляемыхДокументов.ИныеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	ЗаполнитьПоОтборамТаблицуОтображаемыеДокументы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображаемыеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеСтроки = Элемент.ТекущиеДанные;
	ОткрытьФормуЗагружаемогоДокумента(ДанныеСтроки);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого Строка Из ОтображаемыеДокументы Цикл
		Строка.Выбрать = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого Строка Из ОтображаемыеДокументы Цикл
		Строка.Выбрать = Истина;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если НЕ ЗначениеЗаполнено(ОрганизацияСсылка) Тогда
		ТекстСообщения = НСтр("ru = 'Для загрузки необходимо указать организацию.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Выбрать", Истина);
	
	СтрокиВыбранныхДокументов = ОтображаемыеДокументы.НайтиСтроки(ПараметрыОтбора);
	
	Если СтрокиВыбранныхДокументов.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Для загрузки необходимо выбрать хотя бы один документ.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
		
	КонецЕсли;	
	
	МассивИменЗагружаемыхФайлов = Новый Массив;
	СтруктураРезультата = СформироватьСтруктуруРезультатНаСервере(МассивИменЗагружаемыхФайлов);
	
	ОповеститьОВыборе(СтруктураРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииПослеЗагрузкиФайла", ЭтотОбъект);
	
	ЗагрузитьФайл(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииПослеЗагрузкиФайла(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатЗагрузки Тогда
		Закрыть();
	Иначе
		//установим все флажки по умолчанию
		Для Каждого Строка Из ОтображаемыеДокументы Цикл
			Строка.Выбрать = Истина;
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайл(ВыполняемоеОповещение)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлПослеПодключенияРасширенияРаботыСФайлами", ЭтотОбъект, ВыполняемоеОповещение);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения, , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлПослеПодключенияРасширенияРаботыСФайлами(Результат, ВыполняемоеОповещение) Экспорт 

	ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами = Результат;
	
	Если ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами Тогда
		
		ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогВыбора.Заголовок = "Выберите файл для загрузки";
		ДиалогВыбора.МножественныйВыбор = Ложь;
		ДиалогВыбора.ПроверятьСуществованиеФайла = Истина;
		НачалоИмениФайла = "SCAN_";
		ДиалогВыбора.Фильтр = "ZIP архив(" + НачалоИмениФайла + "*.zip)|" + НачалоИмениФайла + "*.zip";
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлПослеВыбораФайла", ЭтотОбъект, ВыполняемоеОповещение);
		ДиалогВыбора.Показать(ОписаниеОповещения);
	
	Иначе
		
		АдресФайлаОбменаВоВременномХранилище = "";
		ИмяФайлаОбмена = "";                                                           
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлЗавершение", ЭтотОбъект, ВыполняемоеОповещение);
		НачатьПомещениеФайла(ОписаниеОповещения, АдресФайлаОбменаВоВременномХранилище, ИмяФайлаОбмена, Истина, УникальныйИдентификатор);
	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлПослеВыбораФайла(МассивПолныхИменВыбранныхФайлов, ВыполняемоеОповещение) Экспорт
	
	Если МассивПолныхИменВыбранныхФайлов = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Ложь);
		Возврат;
	КонецЕсли;
	
	ПолноеИмяФайлаОбменаНаКлиенте = МассивПолныхИменВыбранныхФайлов[0];
	
	ПомещаемыеФайлы = Новый Массив;
	ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ПолноеИмяФайлаОбменаНаКлиенте); 
	ПомещаемыеФайлы.Добавить(ОписаниеФайла);

	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлПослеПомещенияФайла", ЭтотОбъект, ВыполняемоеОповещение); 
	НачатьПомещениеФайлов(ОписаниеОповещения, ПомещаемыеФайлы, Ложь, УникальныйИдентификатор);
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлПослеПомещенияФайла(ПомещенныеФайлы, ВыполняемоеОповещение) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Ложь);
		Возврат;
	КонецЕсли;	
	
	АдресФайлаОбменаВоВременномХранилище = ПомещенныеФайлы[0].Хранение;
		
	Результат = ЗагрузитьФайлНаСервере(АдресФайлаОбменаВоВременномХранилище);
	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлЗавершение(Результат, АдресФайлаОбменаВоВременномХранилище, ИмяФайлаОбмена, ВыполняемоеОповещение) Экспорт
	
	Если Результат Тогда
		Если Прав(ИмяФайлаОбмена,4) = ".zip" Тогда
			Результат = ЗагрузитьФайлНаСервере(АдресФайлаОбменаВоВременномХранилище);
			ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Результат);
			Возврат;
		Иначе
			РегламентированнаяОтчетностьКлиентСервер.СообщитьПользователю("Выбранный файл не является zip-архивом.", ИдентификаторФормыВладельца);
			ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Ложь);
			Возврат;
		КонецЕсли;
	Иначе
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Ложь);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьФайлНаСервере(АдресФайлаОбменаВоВременномХранилище)
	
	ПолноеИмяФайлаОбменаНаСервере = ПолучитьИмяВременногоФайла();
	ПолучитьИзВременногоХранилища(АдресФайлаОбменаВоВременномХранилище).Записать(ПолноеИмяФайлаОбменаНаСервере);
	
	// распаковываем файл описания из архива обмена
	ИмяФайлаОписания = "scandescription.xml";
	ЧтениеЗИП = Новый ЧтениеZipФайла(ПолноеИмяФайлаОбменаНаСервере);
	ЭлементОписание = ЧтениеЗИП.Элементы.Найти(ИмяФайлаОписания);
	Если ЭлементОписание = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	КаталогРаспаковки = ОперацииСФайламиЭДКО.СоздатьВременныйКаталог();
	ЧтениеЗИП.Извлечь(ЭлементОписание, КаталогРаспаковки, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	
	// читаем XML
	ТекстXML = КонтекстЭДОСервер.ПрочитатьТекстИзФайла(КаталогРаспаковки + ИмяФайлаОписания, , Истина);
	Если НЕ ЗначениеЗаполнено(ТекстXML) Тогда
		ЧтениеЗИП.Закрыть();
		КонтекстЭДОСервер.УдалитьВременныйФайл(ПолноеИмяФайлаОбменаНаСервере);
		КонтекстЭДОСервер.УдалитьВременныйФайл(КаталогРаспаковки);
		Возврат Ложь;
	КонецЕсли;
	
	// загружаем XML в дерево
	ДеревоXML = КонтекстЭДОСервер.ЗагрузитьСтрокуXMLВДеревоЗначений(ТекстXML);
	Если НЕ ЗначениеЗаполнено(ДеревоXML) Тогда
		ЧтениеЗИП.Закрыть();
		КонтекстЭДОСервер.УдалитьВременныйФайл(ПолноеИмяФайлаОбменаНаСервере);
		КонтекстЭДОСервер.УдалитьВременныйФайл(КаталогРаспаковки);
		Возврат Ложь;
	КонецЕсли;
	
	// разбираем дерево XML, заполняем таблицу ЗагруженныеДокументы
	Если НЕ ЗаполнитьТаблицуЗагруженныеДокументы(ДеревоXML) Тогда
		Возврат Ложь;	
	КонецЕсли;
	
	//заполняем таблицу ОтображаемыеДокументы
	ЗаполнитьПоОтборамТаблицуОтображаемыеДокументы();
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗначениеСтрокиУзла(Узел, Имя) 
	
	СтрокаУзла = Узел.Строки.Найти(Имя, "Имя");
	Если СтрокаУзла = Неопределено Тогда
		Возврат "";
	Иначе
		Возврат СтрокаУзла.Значение;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьСтрокаУзла(Узел, Имя) 
	
	СтрокаУзла = Узел.Строки.Найти(Имя, "Имя");
	Возврат СтрокаУзла <> Неопределено;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтрокаУзла(Узел, Имя) 
	
	Возврат Узел.Строки.Найти(Имя, "Имя");
	
КонецФункции

&НаСервереБезКонтекста
Функция МассивСтрокУзла(Узел, Имя) 
	
	Возврат Узел.Строки.НайтиСтроки(Новый Структура("Имя", Имя));
	
КонецФункции

&НаСервереБезКонтекста
Функция СтрокаВЧисло(ИсходнаяСтрока)
	// Превращает строку в число без вызова исключений. Стандартная функция преобразования
	//   Число() строго контролирует отсутствие каких-либо символов кроме числовых.
	
	Результат = 0;
	ЗнаковПослеЗапятой = -1;
	ЗнакОтрицательный = Ложь;
	Для НомерСимвола = 1 По СтрДлина(ИсходнаяСтрока) Цикл
		КодСимвола = КодСимвола(ИсходнаяСтрока, НомерСимвола);
		Если КодСимвола = 32 Или КодСимвола = 160 Тогда // Пробел или неразрывный пробел.
			// Пропуск (действие не требуется).
		ИначеЕсли КодСимвола = 45 Тогда // Минус
			Если Результат <> 0 Тогда
				Возврат 0;
			КонецЕсли;
			ЗнакОтрицательный = Истина;
		ИначеЕсли КодСимвола = 44 Или КодСимвола = 46 Тогда // Запятая или точка.
			ЗнаковПослеЗапятой = 0; // Запуск отсчета знаков после запятой.
		ИначеЕсли КодСимвола > 47 И КодСимвола < 58 Тогда // Число.
			Если ЗнаковПослеЗапятой <> -1 Тогда
				ЗнаковПослеЗапятой = ЗнаковПослеЗапятой + 1;
			КонецЕсли;
			Число = КодСимвола - 48;
			Результат = Результат * 10 + Число;
		Иначе
			Возврат 0;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗнаковПослеЗапятой > 0 Тогда
		Результат = Результат / Pow(10, ЗнаковПослеЗапятой);
	КонецЕсли;
	Если ЗнакОтрицательный Тогда
		Результат = -Результат;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция ОпределитьОрганизациюПоИННиКПП(ИНН, КПП)
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.ОпределитьОрганизациюПоИННиКПП(ИНН, КПП);
	
КонецФункции

&НаСервере
Функция ЗаполнитьТаблицуЗагруженныеДокументы(ДеревоXML)
	
	Если НЕ ЕстьСтрокаУзла(ДеревоXML, "Файл") Тогда
		РегламентированнаяОтчетностьКлиентСервер.СообщитьПользователю("Некорректная структура XML файла описания.", ИдентификаторФормыВладельца);
		Возврат Ложь;
	КонецЕсли;
	
	УзелФайл = СтрокаУзла(ДеревоXML, "Файл");
	
	Если НЕ ЕстьСтрокаУзла(УзелФайл, "ВерсФорм")
		ИЛИ НЕ ЕстьСтрокаУзла(УзелФайл, "ДатаВыгрузки")
		ИЛИ НЕ ЕстьСтрокаУзла(УзелФайл, "ВремяВыгрузки")
		ИЛИ НЕ ЕстьСтрокаУзла(УзелФайл, "Организация")
		ИЛИ НЕ ЕстьСтрокаУзла(УзелФайл, "Документ") Тогда
	
		РегламентированнаяОтчетностьКлиентСервер.СообщитьПользователю("Некорректная структура XML файла описания.", ИдентификаторФормыВладельца);
		Возврат Ложь;
	
	КонецЕсли;
	
	ВерсияФормата	 	= СтрокаВЧисло(ЗначениеСтрокиУзла(УзелФайл, "ВерсФорм"));
	Если ВерсияФормата >= 2 Тогда
	
		РегламентированнаяОтчетностьКлиентСервер.СообщитьПользователю("Некорректная структура XML файла описания. Версия формата " + Формат(ВерсияФормата, "ЧДЦ=2; ЧРД=.") + " не поддерживается.", ИдентификаторФормыВладельца);
		Возврат Ложь;
	
	КонецЕсли;

	УзелОрганизация = СтрокаУзла(УзелФайл, "Организация");
	
	//разбираем узел Организация
	Если НЕ ЕстьСтрокаУзла(УзелОрганизация, "Наименование")
		ИЛИ НЕ ЕстьСтрокаУзла(УзелОрганизация, "ИНН") Тогда
		
		РегламентированнаяОтчетностьКлиентСервер.СообщитьПользователю("Некорректная структура XML файла описания.", ИдентификаторФормыВладельца);
		Возврат Ложь;
		
	КонецЕсли;
	
	ИНН = ЗначениеСтрокиУзла(УзелОрганизация, "ИНН");
	КПП = ЗначениеСтрокиУзла(УзелОрганизация, "КПП");
	
	ИННКПП = ИНН + ?(ЗначениеЗаполнено(КПП),"/" + КПП,"");
	
	ОрганизацияСсылка = ОпределитьОрганизациюПоИННиКПП(ИНН, КПП);
	
	Если НЕ ЗначениеЗаполнено(ОрганизацияСсылка) Тогда
		
		Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
			
			РегламентированнаяОтчетностьКлиентСервер.СообщитьПользователю("Пакет обмена предназначен для организации с реквизитами ИНН/КПП: " + ИННКПП + "
			|Установлена для загрузки текущая организация", ИдентификаторФормыВладельца);
			
			Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
			ОрганизацияСсылка = Модуль.ОрганизацияПоУмолчанию();

		Иначе
			РегламентированнаяОтчетностьКлиентСервер.СообщитьПользователю("В справочнике организаций не обнаружено элемента с реквизитами ИНН/КПП: " + ИННКПП, ИдентификаторФормыВладельца);	
		КонецЕсли;
		
	КонецЕсли;

	ПредставлениеОрганизация = ЗначениеСтрокиУзла(УзелОрганизация, "Наименование") + " " + ИННКПП;
	
	ПредставлениеДатаВремяВыгрузки = ЗначениеСтрокиУзла(УзелФайл, "ДатаВыгрузки") + " " 
	+ СтрЗаменить(ЗначениеСтрокиУзла(УзелФайл, "ВремяВыгрузки"), ".", ":");
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Виды = КонтекстЭДОСервер.ВидыПредставляемыхДокументов();
	
	СоответствиеВидовДокументов = Новый Соответствие;
	Для каждого Вид Из Виды Цикл
		Если ЗначениеЗаполнено(Вид.КодПриЗагрузкеСкана) Тогда
			СоответствиеВидовДокументов.Вставить(Вид.КодПриЗагрузкеСкана, Вид.Значение);
		КонецЕсли;
	КонецЦикла; 
	
	Для каждого УзелДокумент Из МассивСтрокУзла(УзелФайл, "Документ") Цикл
		
		Если НЕ ЕстьСтрокаУзла(УзелДокумент, "Вид") 
			ИЛИ НЕ ЕстьСтрокаУзла(УзелДокумент, "Файл") Тогда
			
			РегламентированнаяОтчетностьКлиентСервер.СообщитьПользователю("Некорректная структура XML файла описания.", ИдентификаторФормыВладельца);
			Возврат Ложь;
			
		КонецЕсли;
		
		//добавляем новую строку таблицы ЗагруженныеДокументы и заполняем ее
		НоваяСтрокаДок = ЗагруженныеДокументы.Добавить();
		
		НоваяСтрокаДок.ИдентификаторДокумента = Новый УникальныйИдентификатор;
		
		НоваяСтрокаДок.ВидДокумента 		= СоответствиеВидовДокументов[ЗначениеСтрокиУзла(УзелДокумент, "Вид")];
		НоваяСтрокаДок.НаимДок 				= ЗначениеСтрокиУзла(УзелДокумент, "НаимДок"); // новое поле
		НоваяСтрокаДок.Дата 				= ДатаИзСтроки(ЗначениеСтрокиУзла(УзелДокумент, "Дата"));
		НоваяСтрокаДок.Номер 				= ЗначениеСтрокиУзла(УзелДокумент, "Номер");
		НоваяСтрокаДок.СуммаВсего		 	= СтрокаВЧисло(ЗначениеСтрокиУзла(УзелДокумент, "СуммаВсего"));
		НоваяСтрокаДок.СуммаНалога		 	= СтрокаВЧисло(ЗначениеСтрокиУзла(УзелДокумент, "СуммаНалога"));
		НоваяСтрокаДок.СвДокОсн 			= ЗначениеСтрокиУзла(УзелДокумент, "СвДокОсн"); // новое поле
		НоваяСтрокаДок.НомерОснования 		= ЗначениеСтрокиУзла(УзелДокумент, "НомерОснования");
		НоваяСтрокаДок.ДатаОснования		= ДатаИзСтроки(ЗначениеСтрокиУзла(УзелДокумент, "ДатаОснования"));
		НоваяСтрокаДок.Предмет				= ЗначениеСтрокиУзла(УзелДокумент, "Предмет");
		НоваяСтрокаДок.НачалоПериода		= ДатаИзСтроки(ЗначениеСтрокиУзла(УзелДокумент, "НачалоПериода"));
		НоваяСтрокаДок.КонецПериода			= ДатаИзСтроки(ЗначениеСтрокиУзла(УзелДокумент, "КонецПериода"));
		
		Если ЗначениеЗаполнено(НоваяСтрокаДок.НаимДок) Тогда
			НоваяСтрокаДок.ПредставлениеДокумента = НоваяСтрокаДок.НаимДок;
		Иначе
			
			ПредставлениеДокумента = Строка(НоваяСтрокаДок.ВидДокумента);
		
			Если ЗначениеЗаполнено(НоваяСтрокаДок.Номер) Тогда
				ПредставлениеДокумента = ПредставлениеДокумента + " N " + НоваяСтрокаДок.Номер;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(НоваяСтрокаДок.Дата) Тогда
				ПредставлениеДокумента = ПредставлениеДокумента + " от " + Формат(НоваяСтрокаДок.Дата, "ДЛФ=D");
			КонецЕсли;
			
			НоваяСтрокаДок.ПредставлениеДокумента = ПредставлениеДокумента;
			НоваяСтрокаДок.НаимДок = ПредставлениеДокумента; 
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(НоваяСтрокаДок.СвДокОсн) И 
			(ЗначениеЗаполнено(НоваяСтрокаДок.НомерОснования) ИЛИ ЗначениеЗаполнено(НоваяСтрокаДок.НомерОснования)) Тогда
			
			Если ЗначениеЗаполнено(НоваяСтрокаДок.Дата) Тогда
				ПредставлениеОснования = "N " + НоваяСтрокаДок.Номер + " от " + Формат(НоваяСтрокаДок.Дата, "ДЛФ=D");
			Иначе
				ПредставлениеОснования = "N " + НоваяСтрокаДок.Номер;
			КонецЕсли;
			
			НоваяСтрокаДок.СвДокОсн = ПредставлениеОснования;
			
		КонецЕсли;
		
		
		Для каждого УзелФайл Из МассивСтрокУзла(УзелДокумент, "Файл") Цикл
			
			Если НЕ ЕстьСтрокаУзла(УзелФайл, "Имя") 
				ИЛИ НЕ ЕстьСтрокаУзла(УзелФайл, "Размер") Тогда
				
				РегламентированнаяОтчетностьКлиентСервер.СообщитьПользователю("Некорректная структура XML файла описания.", ИдентификаторФормыВладельца);
				Возврат Ложь;
				
			КонецЕсли;
			
			//добавляем новую строку таблицы ФайлыДокументов и заполняем ее
			НоваяСтрокаФайлы = ФайлыДокументов.Добавить();
			НоваяСтрокаФайлы.ИдентификаторДокумента = НоваяСтрокаДок.ИдентификаторДокумента;
			НоваяСтрокаФайлы.Имя = ЗначениеСтрокиУзла(УзелФайл, "Имя");
			НоваяСтрокаФайлы.Размер = СтрокаВЧисло(ЗначениеСтрокиУзла(УзелФайл, "Размер"));
			НоваяСтрокаФайлы.НомерСтраницы = СтрокаВЧисло(ЗначениеСтрокиУзла(УзелФайл, "НомерСтраницы"));
			НоваяСтрокаФайлы.ИмяНаДиске = ЗначениеСтрокиУзла(УзелФайл, "ИмяНаДиске");
			
			Если НЕ ЗначениеЗаполнено(НоваяСтрокаФайлы.ИмяНаДиске) Тогда
				НоваяСтрокаФайлы.ИмяНаДиске = НоваяСтрокаФайлы.Имя; 
			КонецЕсли;
		
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ДатаИзСтроки(СтрДата)
	Если СтрДата = "" Тогда
		ВозвращаемаяДата = Дата(1, 1, 1);
	Иначе
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрДата, ".");
		Если Число(МассивПодстрок[0]) = 0 Тогда
			МассивПодстрок[0] = "1";
		КонецЕсли;
		Если Число(МассивПодстрок[1]) = 0 Тогда
			МассивПодстрок[1] = "1";
		КонецЕсли;
		Если Число(МассивПодстрок[2]) = 0 Тогда
			МассивПодстрок[2] = "1";
		КонецЕсли;
		ВозвращаемаяДата = Дата(МассивПодстрок[2], МассивПодстрок[1], МассивПодстрок[0]);
	КонецЕсли;
	
	Возврат ВозвращаемаяДата;
	
КонецФункции

&НаСервере
Функция ЗаполнитьПоОтборамТаблицуОтображаемыеДокументы()
	
	ПараметрыОтбора = Новый Структура;
	Если ЗначениеЗаполнено(ВидДокумента) Тогда
		ПараметрыОтбора.Вставить("ВидДокумента", ВидДокумента);
	КонецЕсли;
	
	Если ПараметрыОтбора.Количество() = 0 Тогда
		ОтобранныеСтроки = ЗагруженныеДокументы;	// ОтобранныеСтроки - ТЗ
	Иначе
		ОтобранныеСтроки = ЗагруженныеДокументы.НайтиСтроки(ПараметрыОтбора); // ОтобранныеСтроки - массив строк ТЗ ЗагруженныеДокументы
	КонецЕсли;
	
	ОтображаемыеДокументы.Очистить();
	
	Для каждого ОтобраннаяСтрока Из ОтобранныеСтроки Цикл
		
		НоваяСтрока = ОтображаемыеДокументы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОтобраннаяСтрока); 
			
	КонецЦикла;
		
КонецФункции

&НаСервере
Функция СформироватьСтруктуруРезультатНаСервере(МассивИменЗагружаемыхФайлов)
	
	СтруктураРезультата = Новый Структура;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Выбрать", Истина);
	
	ВыбранныеСтроки = ОтображаемыеДокументы.НайтиСтроки(ПараметрыОтбора);
	
	ТЗОтображаемыеДокументы = РеквизитФормыВЗначение("ОтображаемыеДокументы");
	ВыбранныеДокументы = ТЗОтображаемыеДокументы.Скопировать(Новый Массив);
	
	ТЗФайлыДокументов = РеквизитФормыВЗначение("ФайлыДокументов");
	ФайлыВыбранныхДокументов = ТЗФайлыДокументов.Скопировать(Новый Массив);
	ПараметрыОтбораФайлов = Новый Структура;
	
	Для каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		
		НоваяСтрока = ВыбранныеДокументы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыбраннаяСтрока); 
		
		ПараметрыОтбораФайлов.Вставить("ИдентификаторДокумента", ВыбраннаяСтрока.ИдентификаторДокумента);
		ФайлыВыбранногоДокумента = ТЗФайлыДокументов.НайтиСтроки(ПараметрыОтбораФайлов);
		
		Для каждого ФайлВыбранногоДокумента Из ФайлыВыбранногоДокумента Цикл
			НоваяСтрока = ФайлыВыбранныхДокументов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ФайлВыбранногоДокумента);
			
			МассивИменЗагружаемыхФайлов.Добавить(ФайлВыбранногоДокумента.ИмяНаДиске);
		КонецЦикла;
		
	КонецЦикла;
	
 	АдресТЗВыбранныеДокументы = ПоместитьВоВременноеХранилище(ВыбранныеДокументы, ИдентификаторФормыВладельца);
	СтруктураРезультата.Вставить("АдресТЗЗагруженныеДокументы", АдресТЗВыбранныеДокументы);
	
	АдресТЗФайлыДокументов = ПоместитьВоВременноеХранилище(ФайлыВыбранныхДокументов, ИдентификаторФормыВладельца);
	СтруктураРезультата.Вставить("АдресТЗФайлыДокументов", АдресТЗФайлыДокументов);

	СтруктураРезультата.Вставить("ОрганизацияСсылка", ОрганизацияСсылка);
	
	СтруктураРезультата.Вставить("ПолноеИмяФайлаОбмена", ПолноеИмяФайлаОбменаНаСервере);
	
	Возврат СтруктураРезультата;
			
КонецФункции

&НаСервере
Процедура ДополнитьСтруктуруПараметровНаСервере(СтруктураПараметров, ИдентификаторДокумента)
	
	
	ТЗФайлыДокумента = ФайлыДокументов.Выгрузить(Новый Массив, "ИмяНаДиске, Имя, Размер, НомерСтраницы");
	
	ПараметрыОтбораТЗ = Новый Структура;
	ПараметрыОтбораТЗ.Вставить("ИдентификаторДокумента", ИдентификаторДокумента);
	
	//Файлы документа
	МассивФайловДокумента = ФайлыДокументов.НайтиСтроки(ПараметрыОтбораТЗ); //массив строк ТЗ ФайлыДокументов
	Для каждого СтрокаФайлДокумента Из МассивФайловДокумента Цикл
		
		НоваяСтрокаТЗФайлыДокумента = ТЗФайлыДокумента.Добавить(); 
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТЗФайлыДокумента, СтрокаФайлДокумента);
	
	КонецЦикла;

	
	АдресТЗФайлыДокумента = ПоместитьВоВременноеХранилище(ТЗФайлыДокумента, УникальныйИдентификатор);
	СтруктураПараметров.Вставить("АдресТЗФайлыДокумента", АдресТЗФайлыДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЗагружаемогоДокумента(ДанныеСтроки)
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ВидДокумента", 	ДанныеСтроки.ВидДокумента);
	СтруктураПараметров.Вставить("НаимДок", 		ДанныеСтроки.НаимДок);
	СтруктураПараметров.Вставить("СвДокОсн", 		ДанныеСтроки.СвДокОсн);
	СтруктураПараметров.Вставить("Организация", 	ОрганизацияСсылка);
	
	ДополнитьСтруктуруПараметровНаСервере(СтруктураПараметров, ДанныеСтроки.ИдентификаторДокумента);
	
	ПараметрыФормы = Новый Структура("СтруктураПараметров", СтруктураПараметров);
	ОткрытьФорму("Справочник.СканированныеДокументыДляПередачиВЭлектронномВиде.Форма.ФормаЗагружаемогоДокумента", ПараметрыФормы, ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти
