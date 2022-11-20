///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если НЕ ОблачныйАрхивПовтИсп.РазрешенаРаботаСОблачнымАрхивом() Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	ДатаДляПроверки = ТекущаяУниверсальнаяДата();

	ЭтотОбъект.ГиперссылкаЦвет = ЦветаСтиля.ГиперссылкаЦвет;

	// 1. Получение параметров.
#Область ПолучениеПараметров

	// Сбор информации запускается сразу, а не фоновым заданием.
	ЗагрузитьСтатистику(300);

	// Получить все необходимые параметры.
	ИнформацияОКлиенте = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("ИнформацияОКлиенте", ИмяКомпьютера());
	ЗаполнитьЗначенияСвойств(
		ЭтотОбъект,
		ИнформацияОКлиенте,
		"АгентКопированияУстановлен, ИдентификаторКомпьютера, ВерсияУстановленногоАгентаКопирования, КаталогУстановкиАгентаКопирования");

#Область ДекорацияИнформацияОНовомАгентеРезервногоКопированияТекст

	ПроверкаНеобходимостиОбновленияАгента = ОблачныйАрхив.ПроверкаАктуальностиУстановленногоАгентаРезервногоКопирования(ИнформацияОКлиенте);
	ЗаполнитьЗначенияСвойств(
		ЭтотОбъект,
		ПроверкаНеобходимостиОбновленияАгента,
		"ТребуетсяУстановка, ТребуетсяОбновление, ВерсияНовейшегоАгентаКопирования, РазмерДистрибутиваБайт, СсылкаНаСкачивание, КонтрольнаяСумма, ТекстЧтоНовогоВВерсии, ТекстПорядокОбновления");

	ЭлементИнформацияОНовомАгенте = Элементы.ДекорацияИнформацияОНовомАгентеРезервногоКопированияТекст;
	МассивПодстрок = Новый Массив;
	МассивПодстрок.Добавить(НСтр("ru='Версия дистрибутива:'"));
	МассивПодстрок.Добавить(" ");
	МассивПодстрок.Добавить(
		Новый ФорматированнаяСтрока(
			ИнтернетПоддержкаПользователейКлиентСервер.ПользовательскоеПредставлениеНомераВерсии(
				ЭтотОбъект.ВерсияНовейшегоАгентаКопирования,
				Ложь),
			Новый Шрифт(ЭлементИнформацияОНовомАгенте.Шрифт,,,Истина))); // Жирный.
	МассивПодстрок.Добавить(Символы.ПС);
	МассивПодстрок.Добавить(НСтр("ru='Размер дистрибутива:'"));
	МассивПодстрок.Добавить(" ");
	МассивПодстрок.Добавить(
		Новый ФорматированнаяСтрока(
			Формат(ЭтотОбъект.РазмерДистрибутиваБайт, "ЧЦ=10; ЧДЦ=2; ЧС=6; ЧРД=,; ЧРГ=' '; ЧН=0,00; ЧГ=3,0") + " " + НСтр("ru='МБайт'"),
			Новый Шрифт(ЭлементИнформацияОНовомАгенте.Шрифт,,,Истина))); // Жирный.
	МассивПодстрок.Добавить(Символы.ПС);
	МассивПодстрок.Добавить(Символы.ПС);

	Если НЕ ПустаяСтрока(ЭтотОбъект.ТекстЧтоНовогоВВерсии) Тогда
		МассивПодстрок.Добавить(
			Новый ФорматированнаяСтрока(
					НСтр("ru='Новое в версии.'"),
					,
					ЦветаСтиля.ГиперссылкаЦвет,
					,
					"backup1C:BackupAgentUpdate_WhatIsNew")); // Идентификатор.
		МассивПодстрок.Добавить(Символы.ПС);
		МассивПодстрок.Добавить(Символы.ПС);
	КонецЕсли;

	Если НЕ ПустаяСтрока(ЭтотОбъект.ТекстПорядокОбновления) Тогда
		МассивПодстрок.Добавить(
			СтроковыеФункции.ФорматированнаяСтрока(
				НСтр("ru='Перед установкой обновления необходимо ознакомиться с <a href = ""backup1C:BackupAgentUpdate_HowToUpdate"">особенностями перехода</a> на эту версию Агента резервного копирования.'")));
		МассивПодстрок.Добавить(Символы.ПС);
		МассивПодстрок.Добавить(Символы.ПС);
	КонецЕсли;

	Если ЭтотОбъект.АгентКопированияУстановлен Тогда
		МассивПодстрок.Добавить(НСтр("ru='Установлен Агент резервного копирования версии:'"));
		МассивПодстрок.Добавить(" ");
		МассивПодстрок.Добавить(
			Новый ФорматированнаяСтрока(
					ИнтернетПоддержкаПользователейКлиентСервер.ПользовательскоеПредставлениеНомераВерсии(
						ЭтотОбъект.ВерсияУстановленногоАгентаКопирования,
						Ложь),
					Новый Шрифт(ЭлементИнформацияОНовомАгенте.Шрифт,,,Истина))); // Жирный.
		МассивПодстрок.Добавить(Символы.ПС);
		МассивПодстрок.Добавить(Символы.ПС);
	Иначе
		МассивПодстрок.Добавить(НСтр("ru='Агент резервного копирования не установлен'"));
		МассивПодстрок.Добавить(Символы.ПС);
		МассивПодстрок.Добавить(Символы.ПС);
	КонецЕсли;
	ЭлементИнформацияОНовомАгенте.Заголовок = Новый ФорматированнаяСтрока(МассивПодстрок);

#КонецОбласти

	НастройкиВебСервисов = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("НастройкиВебСервисов");
	ЗаполнитьЗначенияСвойств(
		ЭтотОбъект,
		НастройкиВебСервисов,
		"Таймаут");

#КонецОбласти

	// 2. Создание структуры каталогов для резервной копии.
#Область СозданиеСтруктурыКаталогов
	// Структура каталога для загрузки Агента резервного копирования:
	//  Временный каталог + "\backup1C\BackupAgent\<ФирмаПроизводитель>".
	// Имена загруженных файлов будут формироваться так:
	//  Setup_vА.Б.В.Г.msi, где А.Б.В.Г - версия.
	ЕстьОшибки = Ложь;
	лкКаталогАгента = ИнтернетПоддержкаПользователейКлиентСервер.УдалитьПоследнийСимвол(КаталогВременныхФайлов(), "\/");

	лкКаталогАгента =
		лкКаталогАгента
		+ ПолучитьРазделительПути()
		+ "backup1C";
	Попытка
		СоздатьКаталог(лкКаталогАгента);
	Исключение
		ЕстьОшибки = Истина;
	КонецПопытки;

	Если ЕстьОшибки = Ложь Тогда
		лкКаталогАгента =
			лкКаталогАгента
			+ ПолучитьРазделительПути()
			+ "BackupAgent";
		Попытка
			СоздатьКаталог(лкКаталогАгента);
		Исключение
			ЕстьОшибки = Истина;
		КонецПопытки;

		Если ЕстьОшибки = Ложь Тогда
			лкКаталогАгента =
				лкКаталогАгента
				+ ПолучитьРазделительПути()
				+ "Acronis"; // Имя фирмы-производителя.
			Попытка
				СоздатьКаталог(лкКаталогАгента);
			Исключение
				ЕстьОшибки = Истина;
			КонецПопытки;

			Если ЕстьОшибки = Ложь Тогда
				ЭтотОбъект.КаталогАгента = лкКаталогАгента;

				лкКаталогЗагрузкиАгента =
					ЭтотОбъект.КаталогАгента
					+ ПолучитьРазделительПути()
					+ "Arch"; // Подкаталог инсталляторов.
				Попытка
					СоздатьКаталог(лкКаталогЗагрузкиАгента);
				Исключение
					ЕстьОшибки = Истина;
				КонецПопытки;

				Если ЕстьОшибки = Ложь Тогда
					ЭтотОбъект.КаталогЗагрузкиАгента = лкКаталогЗагрузкиАгента;
				КонецЕсли;

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	ЭтотОбъект.ИмяФайлаУстановки =
		ЭтотОбъект.КаталогЗагрузкиАгента
		+ ПолучитьРазделительПути()
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"Setup_v%1.msi",
			ИнтернетПоддержкаПользователейКлиентСервер.ПользовательскоеПредставлениеНомераВерсии(
				ЭтотОбъект.ВерсияНовейшегоАгентаКопирования,
				Ложь));

	ЭтотОбъект.ИмяФайлаЛоговУстановки =
		ЭтотОбъект.КаталогЗагрузкиАгента
		+ ПолучитьРазделительПути()
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"Setup_v%1_%2.log",
			ИнтернетПоддержкаПользователейКлиентСервер.ПользовательскоеПредставлениеНомераВерсии(
				ЭтотОбъект.ВерсияНовейшегоАгентаКопирования,
				Ложь),
			Формат(ДатаДляПроверки, "ДФ=yyyyMMdd_HHmmss"));

#КонецОбласти

	Если (ЭтотОбъект.ТребуетсяУстановка = Ложь)
			И (ЭтотОбъект.ТребуетсяОбновление = 0) Тогда
		Элементы.ДекорацияУстановкаАгентаРезервногоКопированияЗавершенаУспешноТекст.Заголовок =
			Новый ФорматированнаяСтрока(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Установлена версия Агента резервного копирования: %1'"),
					ИнтернетПоддержкаПользователейКлиентСервер.ПользовательскоеПредставлениеНомераВерсии(
						ЭтотОбъект.ВерсияНовейшегоАгентаКопирования,
						Ложь)),
				Символы.ПС,
				Символы.ПС,
				НСтр("ru='Для настройки расписания автоматического резервного копирования необходимо запустить 1С:Предприятие на компьютере, на котором установлен Агент резервного копирования.'"),
				Символы.ПС,
				Символы.ПС,
				НСтр("ru='Просматривать список созданных резервных копий можно с любого компьютера.'"));
		ПереключитьсяНаСтраницуНаСервере("СтраницаУстановкаАгентаРезервногоКопированияЗавершенаУспешно");
	Иначе
		Если ИнформацияОКлиенте.ЭтоАдминистраторWindows = Истина Тогда
			ПереключитьсяНаСтраницуНаСервере("СтраницаОбновлениеАгентаРезервногоКопирования");
		Иначе
			Элементы.ДекорацияУстановкаАгентаРезервногоКопированияЗавершенаСОшибкамиТекст.Заголовок =
				Новый ФорматированнаяСтрока(
					НСтр("ru='Для обновления Агента резервного копирования необходимо обладать правами администратора Windows.
						|
						|Во время обновления произошли ошибки.
						|Информация об ошибках сохранена в журнал регистрации.'")
						+ Символы.ПС,
					Новый ФорматированнаяСтрока(
						НСтр("ru='Журнал регистрации.'"),
						,
						ЦветаСтиля.ГиперссылкаЦвет,
						,
						"backup1C:EventLog_BackupAgentUpdate"));
			ПереключитьсяНаСтраницуНаСервере("СтраницаУстановкаАгентаРезервногоКопированияЗавершенаСОшибками");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	ПрочиеПараметры = Новый Структура;
	ПрочиеПараметры.Вставить("ТекстЧтоНовогоВВерсии",  ЭтотОбъект.ТекстЧтоНовогоВВерсии);
	ПрочиеПараметры.Вставить("ТекстПорядокОбновления", ЭтотОбъект.ТекстПорядокОбновления);
	ОблачныйАрхивКлиент.ОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ПрочиеПараметры);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)

	ИмяТекущейСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;

	// Проверить возможность перехода "Далее".
	Если ПроверкаВозможностиПереходаНаКлиенте(ИмяТекущейСтраницы, "Далее") Тогда
		// Выполнить переход "Далее".
		ВыполнитьПереходНаКлиенте(ИмяТекущейСтраницы, "Далее");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)

	ИмяТекущейСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;

	// Проверить возможность перехода "Назад".
	Если ПроверкаВозможностиПереходаНаКлиенте(ИмяТекущейСтраницы, "Назад") Тогда
		// Выполнить переход "Назад".
		ВыполнитьПереходНаКлиенте(ИмяТекущейСтраницы, "Назад");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Загружает из веб-сервисов статистику и список резервных копий и собирает информацию о клиентском компьютере.
//
// Параметры:
//  СрокЖизниСтатистики - Число - количество секунд, сколько собранная статистика считается актуальной,
//                        если 0 - обновить принудительно;
//  СписокШагов - Строка - Список шагов, которые необходимо собрать, или пустая строка.
//
&НаСервере
Процедура ЗагрузитьСтатистику(СрокЖизниСтатистики = 300, СписокШагов = "")

	МассивШагов = Новый Массив;

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "ИнформацияОКлиенте"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Сбор информации о клиентском компьютере'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		Если (ПустаяСтрока(СписокШагов))
				ИЛИ (НЕ ПустаяСтрока(СписокШагов) И СтрНайти(СписокШагов, ШагСбораДанных.КодШага)) Тогда
			МассивШагов.Добавить(ШагСбораДанных);
		КонецЕсли;

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "ДоступныеВерсииАгентаКопированияОблачногоАрхива"; // Идентификатор (это НЕ настройка).
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Сбор информации об актуальных версиях Агентов резервного копирования'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		Если (ПустаяСтрока(СписокШагов))
				ИЛИ (НЕ ПустаяСтрока(СписокШагов) И СтрНайти(СписокШагов, ШагСбораДанных.КодШага)) Тогда
			МассивШагов.Добавить(ШагСбораДанных);
		КонецЕсли;

	ОблачныйАрхив.СобратьДанныеПоОблачномуАрхиву(Новый Структура("МассивШагов", МассивШагов), "");

КонецПроцедуры

// Управляет видимостью и доступностью элементов управления.
//
// Параметры:
//  Форма  - Управляемая форма - форма, в которой необходимо установить видимость / доступность.
//
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	ТекущаяСтраница = Элементы.ГруппаСтраницы.ТекущаяСтраница;

	лкНазад      = Элементы.КомандаНазад;
	лкДалее      = Элементы.КомандаДалее;
	лкЗакрыть    = Элементы.КомандаЗакрыть;

	Если ТекущаяСтраница = Элементы.СтраницаДлительнаяОперация Тогда
#Область СтраницаДлительнаяОперация

		лкНазад.Видимость   = Ложь;
		лкДалее.Видимость   = Ложь;
		лкЗакрыть.Видимость = Ложь;

#КонецОбласти

	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаОбновлениеАгентаРезервногоКопирования Тогда
#Область СтраницаОбновлениеАгентаРезервногоКопирования

		лкНазад.Видимость   = Ложь;
		лкДалее.Видимость   = Истина;
		лкЗакрыть.Видимость = Истина;

		лкДалее.Заголовок = НСтр("ru='Обновить'");
		лкДалее.КнопкаПоУмолчанию = Истина;

		лкЗакрыть.Заголовок = НСтр("ru='Отмена'");

#КонецОбласти

	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаУстановкаАгентаРезервногоКопированияЗавершенаСОшибками Тогда
#Область СтраницаУстановкаАгентаРезервногоКопированияЗавершенаСОшибками

		лкНазад.Видимость   = Истина;
		лкДалее.Видимость   = Ложь;
		лкЗакрыть.Видимость = Истина;

		лкЗакрыть.Заголовок = НСтр("ru='Закрыть'");
		лкЗакрыть.КнопкаПоУмолчанию = Истина;

#КонецОбласти

	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаУстановкаАгентаРезервногоКопированияЗавершенаУспешно Тогда
#Область СтраницаУстановкаАгентаРезервногоКопированияЗавершенаУспешно

		лкНазад.Видимость   = Ложь;
		лкДалее.Видимость   = Ложь;
		лкЗакрыть.Видимость = Истина;

		лкЗакрыть.Заголовок = НСтр("ru='Готово'");
		лкЗакрыть.КнопкаПоУмолчанию = Истина;

#КонецОбласти

	КонецЕсли;

КонецПроцедуры

// Функция определяет возможность перехода на другую страницу (на клиенте).
//
// Параметры:
//  ИмяТекущейСтраницы  - Строка - имя текущей страницы;
//  НаправлениеПерехода - Строка - "Далее" или "Назад".
//
// Возвращаемое значение:
//   Булево - ИСТИНА, если переход возможен.
//
&НаКлиенте
Функция ПроверкаВозможностиПереходаНаКлиенте(ИмяТекущейСтраницы, НаправлениеПерехода)

	Результат = Истина;

	Если ИмяТекущейСтраницы = "СтраницаДлительнаяОперация" Тогда
		// Такой переход невозможен.
		Результат = Ложь;
	ИначеЕсли ИмяТекущейСтраницы = "СтраницаУстановкаАгентаРезервногоКопирования" Тогда
		Если НаправлениеПерехода = "Далее" Тогда
			Результат = Истина;
		ИначеЕсли НаправлениеПерехода = "Назад" Тогда
			Результат = Ложь; // Такой переход невозможен
		КонецЕсли;
	ИначеЕсли ИмяТекущейСтраницы = "СтраницаУстановкаАгентаРезервногоКопированияЗавершенаСОшибками" Тогда
		// С этой страницы можно перейти только назад.
		Если НаправлениеПерехода = "Далее" Тогда
			Результат = Ложь;
		ИначеЕсли НаправлениеПерехода = "Назад" Тогда
			Результат = Истина;
		КонецЕсли;
	ИначеЕсли ИмяТекущейСтраницы = "СтраницаУстановкаАгентаРезервногоКопированияЗавершенаУспешно" Тогда
		// С этой страницы возможно только закрытие формы.
		Если НаправлениеПерехода = "Далее" Тогда
			Результат = Ложь;
		ИначеЕсли НаправлениеПерехода = "Назад" Тогда
			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Процедура выполняет переход на другую страницу (на клиенте).
//
// Параметры:
//  ИмяТекущейСтраницы  - Строка - имя текущей страницы;
//  НаправлениеПерехода - Строка - "Далее" или "Назад".
//
&НаКлиенте
Процедура ВыполнитьПереходНаКлиенте(ИмяТекущейСтраницы, НаправлениеПерехода)

	Если ИмяТекущейСтраницы = "СтраницаДлительнаяОперация" Тогда
		// Такой переход невозможен.
	ИначеЕсли ИмяТекущейСтраницы = "СтраницаОбновлениеАгентаРезервногоКопирования" Тогда
		Если НаправлениеПерехода = "Далее" Тогда
			// Всегда переключаться на страницу длительных операций.
			Элементы.ДекорацияДлительнаяОперацияТекст.Заголовок =
				НСтр("ru='Загрузка и обновление Агента резервного копирования.'");
			ПереключитьсяНаСтраницуНаКлиенте("СтраницаДлительнаяОперация");
			// Выполнить все необходимые операции с агентом.
			РезультатОперацииСАгентом = ВыполнитьОперацииСАгентом("ЗагрузкаОбновление");
			Если РезультатОперацииСАгентом.Результат = Истина Тогда
				Элементы.ДекорацияУстановкаАгентаРезервногоКопированияЗавершенаУспешноТекст.Заголовок =
					РезультатОперацииСАгентом.ОписаниеРезультата;
				ПереключитьсяНаСтраницуНаКлиенте("СтраницаУстановкаАгентаРезервногоКопированияЗавершенаУспешно");
			Иначе
				Элементы.ДекорацияУстановкаАгентаРезервногоКопированияЗавершенаСОшибкамиТекст.Заголовок =
					РезультатОперацииСАгентом.ОписаниеРезультата;
				ПереключитьсяНаСтраницуНаКлиенте("СтраницаУстановкаАгентаРезервногоКопированияЗавершенаСОшибками");
			КонецЕсли;
		ИначеЕсли НаправлениеПерехода = "Назад" Тогда
			// Такой переход невозможен.
		КонецЕсли;
	ИначеЕсли ИмяТекущейСтраницы = "СтраницаУстановкаАгентаРезервногоКопированияЗавершенаСОшибками" Тогда
		// С этой страницы возможно только перейти назад.
		Если НаправлениеПерехода = "Далее" Тогда
			// Такой переход невозможен.
		ИначеЕсли НаправлениеПерехода = "Назад" Тогда
			ПереключитьсяНаСтраницуНаКлиенте("СтраницаОбновлениеАгентаРезервногоКопирования");
		КонецЕсли;
	ИначеЕсли ИмяТекущейСтраницы = "СтраницаУстановкаАгентаРезервногоКопированияЗавершенаУспешно" Тогда
		// С этой страницы возможно только закрытие формы.
		Если НаправлениеПерехода = "Далее" Тогда
			// Такой переход невозможен.
		ИначеЕсли НаправлениеПерехода = "Назад" Тогда
			// Такой переход невозможен.
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Выполняет переключение на выбранную страницу с перерисовкой формы.
//
// Параметры:
//  ИмяСтраницы - Строка - имя страницы.
//
&НаКлиенте
Процедура ПереключитьсяНаСтраницуНаКлиенте(ИмяСтраницы)

	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы[ИмяСтраницы];
	УправлениеФормой(ЭтотОбъект);
	ОбновитьОтображениеДанных();

КонецПроцедуры

// Выполняет переключение на выбранную страницу с перерисовкой формы.
//
// Параметры:
//  ИмяСтраницы - Строка - имя страницы.
//
&НаСервере
Процедура ПереключитьсяНаСтраницуНаСервере(ИмяСтраницы)

	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы[ИмяСтраницы];
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

// Функция выполняет операции с агентом резервного копирования: загрузка, установка, активация.
//
// Параметры:
//  ОперацияСАгентом - Строка - идентификатор выполняемых операций. Возможные значения: "Активация", "ЗагрузкаУстановкаАктивация".
//
// Возвращаемое значение:
//   Структура - структура с ключами:
//     * Результат - Булево - Истина, если успешно;
//     * ОписаниеРезультата - ФорматированнаяСтрока, Строка - описание результата.
//
&НаКлиенте
Функция ВыполнитьОперацииСАгентом(ОперацияСАгентом)

	РезультатОперацииСАгентом = Новый Структура("Результат, ОписаниеРезультата", Истина, "");

	#Если НЕ ВебКлиент Тогда

	ОписаниеРезультата = Новый ФорматированнаяСтрока("");

	ЕстьОшибки = Ложь;

	Если (ОперацияСАгентом = "ЗагрузкаОбновление") Тогда

		// 1. Загрузка файла инсталляции агента резервного копирования.
#Область ЗагрузкаФайлаИнсталляции

		ОбновитьНадписиНаСервере(НСтр("ru='Загрузка файла установки агента резервного копирования.'"));

		// Проверить наличие файла установки в каталоге, сравнить его размер и контрольную сумму.
		НеобходимаЗагрузка = Истина;
		ФайлУстановки = Новый Файл(ЭтотОбъект.ИмяФайлаУстановки);
		Если ФайлУстановки.Существует() Тогда
			// Проверить размер.
			Если ФайлУстановки.Размер() = ЭтотОбъект.РазмерДистрибутиваБайт Тогда
				// Проверить контрольную сумму.
				Если СовпадаетКонтрольнаяСумма(ЭтотОбъект.ИмяФайлаУстановки, ЭтотОбъект.КонтрольнаяСумма) Тогда
					НеобходимаЗагрузка = Ложь;
					ОписаниеРезультата = Новый ФорматированнаяСтрока(
						ОписаниеРезультата,
						Символы.ПС,
						НСтр("ru='Агент резервного копирования успешно загружен'"));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если НеобходимаЗагрузка = Истина Тогда
			ПараметрыПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла();
			ПараметрыПолучения.Вставить("ПутьДляСохранения", ЭтотОбъект.ИмяФайлаУстановки);
			ПараметрыПолучения.Вставить("Таймаут", ЭтотОбъект.Таймаут);

			РезультатЗагрузки = ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте(
				ЭтотОбъект.СсылкаНаСкачивание, // URL.
				ПараметрыПолучения, // ПараметрыПолучения.
				Истина); // ЗаписыватьОшибку.

			Если РезультатЗагрузки.Статус = Истина Тогда
				ФайлУстановки = Новый Файл(ЭтотОбъект.ИмяФайлаУстановки);
				ФайлУстановкиСуществует = ФайлУстановки.Существует();
				Если ФайлУстановкиСуществует = Истина Тогда
					// Проверить размер.
					Если ФайлУстановки.Размер() = ЭтотОбъект.РазмерДистрибутиваБайт Тогда
						// Проверить контрольную сумму.
						Если НЕ СовпадаетКонтрольнаяСумма(ЭтотОбъект.ИмяФайлаУстановки, ЭтотОбъект.КонтрольнаяСумма) Тогда
							ЕстьОшибки = Истина;
							ОписаниеРезультата = Новый ФорматированнаяСтрока(
								ОписаниеРезультата,
								Символы.ПС,
								НСтр("ru='Файл дистрибутива повреждён (контрольная сумма загруженного дистрибутива отличается от указанной на сайте)'")); // АПК:163 выводится пользователю.
						Иначе
							ОписаниеРезультата = Новый ФорматированнаяСтрока(
								ОписаниеРезультата,
								Символы.ПС,
								НСтр("ru='Агент резервного копирования успешно загружен'"));
						КонецЕсли;
					Иначе
						ЕстьОшибки = Истина;
						ОписаниеРезультата = Новый ФорматированнаяСтрока(
							ОписаниеРезультата,
							Символы.ПС,
							НСтр("ru='Файл дистрибутива повреждён (размер загруженного дистрибутива отличается от указанного на сайте)'")); // АПК:163 выводится пользователю.
					КонецЕсли;
				Иначе
					ЕстьОшибки = Истина;
					ОписаниеРезультата = Новый ФорматированнаяСтрока(
						ОписаниеРезультата,
						Символы.ПС,
						НСтр("ru='Файл дистрибутива отсутствует во временном каталоге.'"));
				КонецЕсли;
			Иначе // Не удалось загрузить...
				ЕстьОшибки = Истина;
				ОписаниеРезультата = Новый ФорматированнаяСтрока(
					ОписаниеРезультата,
					Символы.ПС,
					НСтр("ru='Файл дистрибутива не загружен. Произошли непредвиденные ошибки.'"));
			КонецЕсли;
		КонецЕсли;

#КонецОбласти

		// 2. Запуск инсталляции агента резервного копирования.
#Область ЗапускИнсталляции

		// Строка команды зависит от настроек, заданных при начале инсталляции.
		Если ЕстьОшибки <> Истина Тогда
			ОбновитьНадписиНаСервере(НСтр("ru='Запуск установки агента резервного копирования.'"));
			ОписаниеРезультата = Новый ФорматированнаяСтрока(
				ОписаниеРезультата,
				Символы.ПС,
				НСтр("ru='Агент резервного копирования успешно установлен'"));

			ФайлУстановки = Новый Файл(ЭтотОбъект.ИмяФайлаУстановки);
			ФайлУстановкиСуществует = ФайлУстановки.Существует();
			Если ФайлУстановкиСуществует = Истина Тогда

				СтрокаКоманды =
					"msiexec /package "
					+ """"
					+ ЭтотОбъект.ИмяФайлаУстановки
					+ """"
					+ " /liwearucmopvx " // Ключи установки
					+ """"
					+ ЭтотОбъект.ИмяФайлаЛоговУстановки
					+ """"
					+ " /qf " // Все диалоговые окна.
					+ " /promptrestart " // Если нужно перезагрузить компьютер, то сделать это.
					+ " REINSTALL=ALL REINSTALLMODE=vamus "; // Необходимость переинсталляции.

				// Окно должно быть видимо.
				ПараметрыЗапускаПрограммы = ФайловаяСистемаКлиент.ПараметрыЗапускаПрограммы();
				ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина; // Необходимо для получения потока ошибок.
				ПараметрыЗапускаПрограммы.ТекущийКаталог      = ЭтотОбъект.КаталогУстановкиАгентаКопирования;
				ФайловаяСистемаКлиент.ЗапуститьПрограмму(СтрокаКоманды, ПараметрыЗапускаПрограммы);

			КонецЕсли;
		КонецЕсли;

#КонецОбласти

		// 3. Заново собрать настройки (каталог установки).
#Область СборИнформации_ИнформацияОКлиенте

		Если ЕстьОшибки <> Истина Тогда
			ОбновитьНадписиНаСервере(НСтр("ru='Сбор данных для агента резервного копирования (анализ состояния компьютера).'"));
			ОписаниеРезультата = Новый ФорматированнаяСтрока(
				ОписаниеРезультата,
				Символы.ПС,
				НСтр("ru='Все операции с агентом на компьютере завершены.'"));

			ЗагрузитьСтатистику(0, "ИнформацияОКлиенте");
		КонецЕсли;

#КонецОбласти

		// 4. Окончание.
#Область Окончание

		Если ЕстьОшибки = Истина Тогда
			ОбновитьНадписиНаСервере(НСтр("ru='Есть ошибки'"));
			// Предыдущие описания не важны, их можно очищать.
			ОписаниеРезультата = 
				Новый ФорматированнаяСтрока(
					НСтр("ru='Для обновления Агента резервного копирования необходимо обладать правами администратора Windows.
						|
						|Во время обновления произошли ошибки.
						|Информация об ошибках сохранена в журнал регистрации.'")
						+ Символы.ПС,
					Новый ФорматированнаяСтрока(
						НСтр("ru='Журнал регистрации.'"),
						,
						ЭтотОбъект.ГиперссылкаЦвет,
						,
						"backup1C:EventLog_BackupAgentUpdate"));
		Иначе
			ОбновитьНадписиНаСервере(НСтр("ru='Всё готово'")); // АПК:163 выводится пользователю.
			// Предыдущие описания не важны, их можно очищать.
			ОписаниеРезультата = 
				Новый ФорматированнаяСтрока(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Установлена версия Агента резервного копирования: %1'"),
						ИнтернетПоддержкаПользователейКлиентСервер.ПользовательскоеПредставлениеНомераВерсии(
							ЭтотОбъект.ВерсияНовейшегоАгентаКопирования,
							Ложь)),
					Символы.ПС,
					Символы.ПС,
					НСтр("ru='Для настройки расписания автоматического резервного копирования необходимо запустить 1С:Предприятие на компьютере, на котором установлен Агент резервного копирования.'"),
					Символы.ПС,
					Символы.ПС,
					НСтр("ru='Просматривать список созданных резервных копий можно с любого компьютера.'"));
		КонецЕсли;

#КонецОбласти

	КонецЕсли;

	РезультатОперацииСАгентом.Вставить("ОписаниеРезультата", ОписаниеРезультата);

	#КонецЕсли

	Возврат РезультатОперацииСАгентом;

КонецФункции

// Процедура для обновления заголовков декорации длительных операций на форме.
//
// Параметры:
//  Надпись - Форматированная строка - заголовок декорации.
//
&НаСервере
Процедура ОбновитьНадписиНаСервере(Надпись)

	Элементы.ДекорацияДлительнаяОперацияТекст.Заголовок = Надпись;

КонецПроцедуры

// Функция сравнивает эталонную контрольную сумму с контрольной суммой файла.
//
// Параметры:
//  ИмяФайла - Строка - Имя проверяемого файла. Так как подсистема рассчитана на работу в файловом варианте,
//                      то на клиенте и на сервере имя файла одинаковое.
//  КонтрольнаяСумма - Строка - эталонная контрольная сумма.
//
// Возвращаемое значение:
//   Булево - Истина, если контрольная сумма файла совпадает с эталонной.
//
&НаСервереБезКонтекста
Функция СовпадаетКонтрольнаяСумма(ИмяФайла, КонтрольнаяСумма)

	Результат = Ложь;

	Хеш = Новый ХешированиеДанных(ХешФункция.MD5);
	Хеш.ДобавитьФайл(ИмяФайла);
	РассчитаннаяКонтрольнаяСумма = СтрЗаменить(Строка(Хеш.ХешСумма), " ", "");
	Результат = (НРег(КонтрольнаяСумма) = НРег(РассчитаннаяКонтрольнаяСумма));

	Возврат Результат;

КонецФункции

#КонецОбласти
