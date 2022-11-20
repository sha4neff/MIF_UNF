///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СвойстваВременногоФайла = ФайлыБТС.СвойстваНовогоВременногоФайла("zip");
	Элементы.ЗагружатьРасширенияКонфигурации.Видимость = Не РаботаВМоделиСервиса.РазделениеВключено();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОткрытьФормуАктивныхПользователей(Элемент)
	
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма.АктивныеПользователи");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если ЭтоПовторноеНажатие Тогда
		ЗавершитьЗагрузкуДанных();
	Иначе
		СвойстваФайла = СвойстваВременногоФайла; // см. ФайлыБТС.СвойстваНовогоВременногоФайла
		ПараметрыПередачи = ФайлыБТСКлиент.ПараметрыПомещенияФайла();
		ПараметрыПередачи.ИмяФайлаИлиАдрес = СвойстваФайла.Имя;
		ПараметрыПередачи.ПутьФайлаWindows = СвойстваФайла.ПутьWindows;
		ПараметрыПередачи.ПутьФайлаLinux = СвойстваФайла.ПутьLinux;
		ПараметрыПередачи.ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ПродолжитьЗагрузкуДанных", ЭтотОбъект);
		ПараметрыПередачи.БлокируемаяФорма = ЭтотОбъект;
		ПараметрыПередачи.ЗаголовокДиалогаВыбора = НСтр("ru = 'Загрузка файла'");
		ПараметрыПередачи.ФильтрДиалогаВыбора = СтрШаблон(НСтр("ru = 'Архивы %1'"), "(*.zip)|*.zip");
		ПараметрыПередачи.ИмяФайлаДиалогаВыбора = 
			ВыгрузкаЗагрузкаДанныхКлиентСервер.ИмяФайлаВыгрузкиДанных();
		
		ФайлыБТСКлиент.ПоместитьФайлИнтерактивно(ПараметрыПередачи);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗагрузкуДанных(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		УдалитьВременныеДанныеПослеЗагрузки(СвойстваВременногоФайла);
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоПовторноеНажатие И ФайлДанныхСодержитПоставляемыеРасширения(СвойстваВременногоФайла) Тогда
		ЭтоПовторноеНажатие = Истина;
		Возврат;					
	КонецЕсли;
	
	Если ВыгрузкаДляТехническойПоддержки(СвойстваВременногоФайла) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросОПродолженииЗагрузкиЗавершение", ЭтотОбъект);
		
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Файл данных создан в режиме выгрузки для технической поддержки.
      		|Приложение полученное из такой выгрузки предназначено только для целей тестирования и разбора проблем. Продолжить загрузку?'"),
			РежимДиалогаВопрос.ОКОтмена,,
			КодВозвратаДиалога.Отмена);
		
	Иначе		
		ЗавершитьЗагрузкуДанных();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПродолженииЗагрузкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ЗавершитьЗагрузкуДанных();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗавершитьЗагрузкуДанных()
	
	Состояние(
		НСтр("ru = 'Выполняется загрузка данных из сервиса.
		|Операция может занять продолжительное время, пожалуйста, подождите...'"),);
	
		ВыполнитьЗагрузку(СвойстваВременногоФайла, ЗагружатьИнформациюОПользователях, ЗагружатьРасширенияКонфигурации);
		УдалитьВременныеДанныеПослеЗагрузки(СвойстваВременногоФайла);
		ПрекратитьРаботуСистемы(Истина);
	
КонецПроцедуры

// Параметры:
// 	СвойстваВременногоФайла - см. ФайлыБТС.СвойстваНовогоВременногоФайла
//
&НаСервереБезКонтекста
Процедура УдалитьВременныеДанныеПослеЗагрузки(СвойстваВременногоФайла)

	Если ЗначениеЗаполнено(СвойстваВременногоФайла.Имя) Тогда
		
		ИмяФайлаНаСервере = ФайлыБТС.ПолноеИмяФайлаВСеансе(СвойстваВременногоФайла.Имя,
		СвойстваВременногоФайла.ПутьWindows,
		СвойстваВременногоФайла.ПутьLinux);
		
		УдалитьФайлыВПопытке(ИмяФайлаНаСервере);
		
	КонецЕсли;

КонецПроцедуры

// Параметры:
// 	СвойстваВременногоФайла - см. ФайлыБТС.СвойстваНовогоВременногоФайла
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеАрхива(СвойстваВременногоФайла)

	ИмяФайлаНаСервере = ФайлыБТС.ПолноеИмяФайлаВСеансе(СвойстваВременногоФайла.Имя,
	СвойстваВременногоФайла.ПутьWindows,
	СвойстваВременногоФайла.ПутьLinux);
	
	Возврат Новый ДвоичныеДанные(ИмяФайлаНаСервере);
	
КонецФункции

&НаСервереБезКонтекста
Функция ФайлДанныхСодержитПоставляемыеРасширения(СвойстваВременногоФайла)
	
	ФайлРасширений = "Extensions.xml";
	
	ДанныеАрхива = ПолучитьДанныеАрхива(СвойстваВременногоФайла);
	Поток = ДанныеАрхива.ОткрытьПотокДляЧтения();
	
	ЧтениеZIP = Новый ЧтениеZipФайла(Поток);
	ЭлементZip = ЧтениеZIP.Элементы.Найти(ФайлРасширений);
	
	Если ЭлементZip = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИмяКаталогаАрхива = ПолучитьИмяВременногоФайла("zip") + ПолучитьРазделительПути();
	СоздатьКаталог(ИмяКаталогаАрхива);
	
	ЧтениеZIP.Извлечь(ЭлементZip, ИмяКаталогаАрхива, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	ЧтениеZIP.Закрыть();
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяКаталогаАрхива + ФайлРасширений);
	ЧтениеXML.ПерейтиКСодержимому();
	
	Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента Или ЧтениеXML.Имя <> "Data" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МассивВерсий = Новый Массив;
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента И ЧтениеXML.Имя <> "Extensions" Тогда		
			ЧтениеXML.Прочитать();
			Продолжить;	
		КонецЕсли;
		
		ИзменяетСтруктуруДанных = XMLЗначение(Тип("Булево"), ЧтениеXML.ЗначениеАтрибута("ModifiesDataStructure"));
		Наименование = XMLЗначение(Тип("Строка"), ЧтениеXML.ЗначениеАтрибута("Name"));
		
		Если НЕ ИзменяетСтруктуруДанных Тогда
			Продолжить;
		КонецЕсли;
		
		МассивВерсий.Добавить(Наименование);
		
	КонецЦикла;
	
	Если МассивВерсий.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтрокаСообщения = НСтр("ru = 'Выбранный файл содержит данные добавленные расширениями.'") 
		+ Символы.ПС + НСтр("ru = 'Для восстановления из данного архива установите следующие расширения:'");
	ОбщегоНазначения.СообщитьПользователю(СтрокаСообщения);
	
	Для Каждого Расширение Из МассивВерсий Цикл
		ОбщегоНазначения.СообщитьПользователю(Расширение);			
	КонецЦикла;
	
	ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Если все необходимые расширения уже установлены, тогда нажмите ''Продолжить'''"));
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ВыполнитьЗагрузку(Знач СвойстваВременногоФайла, Знач ЗагружатьИнформацияОПользователях, Знач ЗагружатьРасширенияКонфигурации)
	
	УстановитьМонопольныйРежим(Истина);
	
	Попытка
		
		ДанныеАрхива = ПолучитьДанныеАрхива(СвойстваВременногоФайла); // ДвоичныеДанные
		ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		ДанныеАрхива.Записать(ИмяАрхива);
		
		ДанныеРасширений = Неопределено;	
		Если ЗагружатьРасширенияКонфигурации Тогда
			РасширенияДляВосстановления = РасширенияДляВосстановления(ДанныеАрхива);
			Если ЗначениеЗаполнено(РасширенияДляВосстановления) Тогда
				ДанныеРасширений = Новый Структура("РасширенияДляВосстановления", РасширенияДляВосстановления);
			КонецЕсли;
		КонецЕсли;
				
		ВыгрузкаЗагрузкаОбластейДанных.ЗагрузитьТекущуюОбластьИзАрхива(ИмяАрхива, 
			ЗагружатьИнформацияОПользователях, 
			Истина,, 
			ДанныеРасширений);
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(ИмяАрхива);
		
		УстановитьМонопольныйРежим(Ложь);
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		УстановитьМонопольныйРежим(Ложь);
		
		УдалитьВременныеДанныеПослеЗагрузки(СвойстваВременногоФайла);
		
		ШаблонЗаписиЖР = НСтр("ru = 'При загрузке данных произошла ошибка:
                               |
                               |-----------------------------------------
                               |%1
                               |-----------------------------------------'");
		ТекстЗаписиЖР = СтрШаблон(ШаблонЗаписиЖР, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));

		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Загрузка данных'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ТекстЗаписиЖР);

		ШаблонИсключения = НСтр("ru = 'При загрузке данных произошла ошибка: %1.
                                 |
                                 |Расширенная информация для службы поддержки записана в журнал регистрации. Если причина ошибки неизвестна - рекомендуется обратиться в службу технической поддержки, предоставив для расследования выгрузку журнала регистрации и файл, из которого предпринималась попытка загрузить данные.'");

		ВызватьИсключение СтрШаблон(ШаблонИсключения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыгрузкаДляТехническойПоддержки(СвойстваВременногоФайла)
	
	ДайджестВыгрузки = ДайджестВыгрузки(СвойстваВременногоФайла); // ДокументDOM
	
	Если ДайджестВыгрузки <> Неопределено Тогда
		СписокЭлементов = ДайджестВыгрузки.ПолучитьЭлементыПоИмени("DataDumpType");
		ВыгрузкаДляТехническойПоддержки = ЗначениеЗаполнено(СписокЭлементов) И СписокЭлементов[0].ТекстовоеСодержимое = "TechnicalSupport";	
	Иначе
		ВыгрузкаДляТехническойПоддержки = Ложь;
	КонецЕсли;
	
	Возврат ВыгрузкаДляТехническойПоддержки;

КонецФункции  

&НаСервереБезКонтекста
Функция ДайджестВыгрузки(СвойстваВременногоФайла) Экспорт
		
	ДанныеАрхива = ПолучитьДанныеАрхива(СвойстваВременногоФайла);
	Поток = ДанныеАрхива.ОткрытьПотокДляЧтения();
	
	ЧтениеZIP = Новый ЧтениеZipФайла(Поток);
	
	Элемент = ЧтениеZIP.Элементы.Найти("Digest.xml");
	
	Если Элемент = Неопределено Тогда
		Возврат Неопределено;		
	КонецЕсли;
		
	КаталогВыгрузки = ПолучитьИмяВременногоФайла();
	КаталогВыгрузки = КаталогВыгрузки + ПолучитьРазделительПути();
	
	ЧтениеZIP.Извлечь(Элемент, КаталогВыгрузки, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	ЧтениеZIP.Закрыть();	
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(КаталогВыгрузки + Элемент.Имя);
	
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	
	ЧтениеXML.Закрыть();
	
	УдалитьФайлыВПопытке(КаталогВыгрузки);

	Возврат ДокументDOM;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьФайлыВПопытке(ИмяПапкиИлиФайла)
	
	ИмяСобытияЖР = НСтр("ru = 'Удаление файла.Загрузка файла выгрузки'", ОбщегоНазначения.КодОсновногоЯзыка());
	ФайлыБТС.УдалитьФайлыВПопытке(ИмяПапкиИлиФайла, ИмяСобытияЖР);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РасширенияДляВосстановления(ДанныеАрхива)

	РасширенияДляВосстановления = Неопределено;

	ИмяФайлаПользовательскихРасширений = "CustomExtensions.json";
	ПотокЧтенияДанныхАрхива = ДанныеАрхива.ОткрытьПотокДляЧтения();
	РазделительПути = ПолучитьРазделительПути();
	ТипУникальныйИдентификатор = Тип("УникальныйИдентификатор");

	Попытка
		ЧтениеДанныхАрхива = Новый ЧтениеZipФайла(ПотокЧтенияДанныхАрхива);

		ЭлементФайлПользовательскихРасширений = ЧтениеДанныхАрхива.Элементы.Найти(ИмяФайлаПользовательскихРасширений);

		Если ЭлементФайлПользовательскихРасширений = Неопределено Тогда
			ПотокЧтенияДанныхАрхива.Закрыть();
			Возврат РасширенияДляВосстановления;
		КонецЕсли;

		КаталогРаспаковки = ПолучитьИмяВременногоФайла();

		ЧтениеДанныхАрхива.Извлечь(ЭлементФайлПользовательскихРасширений, КаталогРаспаковки,
			РежимВосстановленияПутейФайловZIP.НеВосстанавливать);

		ЧтениеФайлаПользовательскихРасширений = Новый ЧтениеJSON;
		ЧтениеФайлаПользовательскихРасширений.ОткрытьФайл(СтрШаблон("%1%2%3", КаталогРаспаковки, РазделительПути, ИмяФайлаПользовательскихРасширений));

		ИнформацияОПользовательскихРасширениях = ПрочитатьJSON(ЧтениеФайлаПользовательскихРасширений);
		ЧтениеФайлаПользовательскихРасширений.Закрыть();

		РасширенияДляВосстановления = Новый Массив();

		Для Каждого ИнформацияОПользовательскомРасширении Из ИнформацияОПользовательскихРасширениях Цикл
			
			ИмяФайлаПользовательскогоРасширения = Неопределено;
			Если Не ИнформацияОПользовательскомРасширении.Свойство("FileName", ИмяФайлаПользовательскогоРасширения)
				Или Не ЗначениеЗаполнено(ИмяФайлаПользовательскогоРасширения) Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлементФайлПользовательскогоРасширения = ЧтениеДанныхАрхива.Элементы.Найти(
				ИмяФайлаПользовательскогоРасширения);

			Если ЭлементФайлПользовательскогоРасширения = Неопределено Тогда
				ВызватьИсключение СтрШаблон(Нстр("ru = 'Не найден файл данных расширения %1'"),
					ИмяФайлаПользовательскогоРасширения);
			КонецЕсли;

			ЧтениеДанныхАрхива.Извлечь(ЭлементФайлПользовательскогоРасширения, КаталогРаспаковки,
				РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
			
			РасширениеДляВосстановления = Новый Структура();
			РасширениеДляВосстановления.Вставить("Активно", ИнформацияОПользовательскомРасширении.Active);
			РасширениеДляВосстановления.Вставить("БезопасныйРежим", ИнформацияОПользовательскомРасширении.SafeMode); 
			
			ЗащитаОтОпасныхДействий = Новый ОписаниеЗащитыОтОпасныхДействий;
			ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = ИнформацияОПользовательскомРасширении.UnsafeOperationWarnings;
			РасширениеДляВосстановления.Вставить("ЗащитаОтОпасныхДействий", ЗащитаОтОпасныхДействий); 
			
			РасширениеДляВосстановления.Вставить("Имя", ИнформацияОПользовательскомРасширении.Name); 
			РасширениеДляВосстановления.Вставить("ИспользоватьОсновныеРолиДляВсехПользователей", 
				ИнформацияОПользовательскомРасширении.UseDefaultRolesForAllUsers); 
			РасширениеДляВосстановления.Вставить("ИспользуетсяВРаспределеннойИнформационнойБазе", 
				ИнформацияОПользовательскомРасширении.UsedInDistributedInfoBase); 	
			РасширениеДляВосстановления.Вставить("Синоним", ИнформацияОПользовательскомРасширении.Synonym); 	
			РасширениеДляВосстановления.Вставить("ИзменяетСтруктуруДанных", 
				ИнформацияОПользовательскомРасширении.ModifiesDataStructure); 	
			РасширениеДляВосстановления.Вставить("УникальныйИдентификатор", XMLЗначение(ТипУникальныйИдентификатор,
				ИнформацияОПользовательскомРасширении.UUID)); 	
			ДанныеФайлаПользовательскогоРасширения =  Новый ДвоичныеДанные(СтрШаблон("%1%2%3", КаталогРаспаковки,
				РазделительПути, ИмяФайлаПользовательскогоРасширения));
			РасширениеДляВосстановления.Вставить("Данные", ДанныеФайлаПользовательскогоРасширения); 	
				
			РасширенияДляВосстановления.Добавить(РасширениеДляВосстановления);

		КонецЦикла;

		УдалитьФайлыВПопытке(КаталогРаспаковки);

	Исключение
		ПотокЧтенияДанныхАрхива.Закрыть();
		ВызватьИсключение;
	КонецПопытки;
	ПотокЧтенияДанныхАрхива.Закрыть();

	Возврат РасширенияДляВосстановления;
КонецФункции

#КонецОбласти