///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция Подключены() Экспорт
	
	Если Заблокированы() Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	// Вызов на сервере гарантирует получение корректного состояния в случае,
	// когда данные регистрации информационной базы были изменены методом 
	// СистемаВзаимодействия.УстановитьДанныеРегистрацииИнформационнойБазы.
	Возврат СистемаВзаимодействия.ИспользованиеДоступно();
	
КонецФункции

Функция Заблокированы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеРегистрации = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		"ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия");
	Заблокированы = ДанныеРегистрации <> Неопределено;
	Возврат Заблокированы;
	
КонецФункции

Процедура Заблокировать() Экспорт 
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда 
		ВызватьИсключение 
			НСтр("ru = 'Обсуждения не заблокированы. Для выполнения операции требуется право администрирования данных.'");
	КонецЕсли;
	
	Если Заблокированы() Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеРегистрации = СистемаВзаимодействия.ПолучитьДанныеРегистрацииИнформационнойБазы();
	Если ТипЗнч(ДанныеРегистрации) = Тип("ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия") Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
			"ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия", 
			ДанныеРегистрации);
	КонецЕсли;
	СистемаВзаимодействия.УстановитьДанныеРегистрацииИнформационнойБазы(Неопределено);
	
КонецПроцедуры

Процедура Разблокировать() Экспорт 
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда 
		ВызватьИсключение 
			НСтр("ru = 'Обсуждения не заблокированы. Для выполнения операции требуется право администрирования данных.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеРегистрации = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		"ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия");
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища("ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия");
	Если ТипЗнч(ДанныеРегистрации) = Тип("ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия") Тогда 
		СистемаВзаимодействия.УстановитьДанныеРегистрацииИнформационнойБазы(ДанныеРегистрации);
	КонецЕсли;
	ДанныеРегистрации = Неопределено;
	
КонецПроцедуры

// Параметры:
//  Отказ - Булево
//  Форма - ФормаКлиентскогоПриложения
//        - РасширениеУправляемойФормыДляОбъектов
//  Объект - ДанныеФормыСтруктура
//         - СправочникОбъект.Пользователи
//
Процедура ПриСозданииНаСервереПользователя(Отказ, Форма, Объект) Экспорт
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда
		Форма.ПредлагатьОбсуждения = Ложь;
		Возврат;
	КонецЕсли;
	
	ПредлагатьОбсуждения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПрограммы", "ПредлагатьОбсуждения", Истина);
	Форма.ПредлагатьОбсуждения = Не Отказ И Не ЗначениеЗаполнено(Объект.Ссылка) И ПредлагатьОбсуждения 
		И Не ОбсужденияСлужебныйВызовСервера.Подключены();
	Если Не Форма.ПредлагатьОбсуждения Тогда
		Возврат;
	КонецЕсли;
	
	ПодсистемаАдминистрирование = Метаданные.Подсистемы.Найти("Администрирование");
	Если ПодсистемаАдминистрирование <> Неопределено Тогда 
		ВключитьПозднее = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Включить обсуждения также можно позднее из раздела %1.'"),
			ПодсистемаАдминистрирование.Синоним);
	Иначе
		ВключитьПозднее = НСтр("ru = 'Включить обсуждения также можно позднее из настроек программы.'");
	КонецЕсли;
	
	Форма.ПредлагатьОбсужденияТекст = 
		НСтр("ru = 'Включить обсуждения?
			       |
			       |С их помощью пользователи смогут отправлять друг другу текстовые сообщения и совершать видеозвонки, создавать тематические обсуждения и вести переписку по документам.'")
			+ Символы.ПС + Символы.ПС + ВключитьПозднее;
	
КонецПроцедуры

// Параметры:
//  Данные  - СправочникСсылка.ВариантыОтчетов
//  Заголовок  - Строка
//
// Возвращаемое значение:
//   ОбсуждениеСистемыВзаимодействия
//
Функция ОбсуждениеКонтекстное(Данные, Заголовок = Неопределено) Экспорт
	
	Обсуждение = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	
	КонтекстОбсуждения = Новый КонтекстОбсужденияСистемыВзаимодействия(
		ПолучитьНавигационнуюСсылку(Данные));
	
	ОтборОбсуждений = Новый ОтборОбсужденийСистемыВзаимодействия();
	ОтборОбсуждений.КонтекстноеОбсуждение = Истина;
	ОтборОбсуждений.КонтекстОбсуждения = КонтекстОбсуждения;
	
	НайденноеОбсуждения = Вычислить("СистемаВзаимодействия.ПолучитьОбсуждения(ОтборОбсуждений)");
	
	Если НайденноеОбсуждения.Количество() > 0 Тогда
		Возврат НайденноеОбсуждения[0];
	КонецЕсли;
	
	Если Заголовок = Неопределено Тогда 
		
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'История %1'"), Данные);
		
	КонецЕсли;
	
	Обсуждение = Вычислить("СистемаВзаимодействия.СоздатьОбсуждение()");
	Обсуждение.Заголовок = Заголовок;
	Обсуждение.КонтекстОбсуждения = КонтекстОбсуждения;
	
	Обсуждение.Записать();
	
	Возврат Обсуждение;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// Параметры:
//  ЗапросыРазрешений - см. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.ЗапросыРазрешений
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	Разрешение = МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса("WSS", "1cdialog.com", 443, 
		НСтр("ru = 'Сервис 1С:Диалог для системы взаимодействия (тематические обсуждения, переписка и видеозвонки между пользователями программы).'"));
	Разрешения = Новый Массив;
	Разрешения.Добавить(Разрешение);
	ЗапросыРазрешений.Добавить(МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения));
	
КонецПроцедуры

// см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.3.282";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("b3be68c5-708d-42c9-a019-818036d09d06");
	Обработчик.Процедура = "ОбсужденияСлужебный.ЗаблокироватьНедействительныхПользователейВСистемеВзаимодействий";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru='Блокировка недействительных пользователей в системе взаимодействия.'");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ОбсужденияСлужебный.ПользователиДляБлокировкиВСистемеВзаимодействий";
	Обработчик.ЧитаемыеОбъекты = "Справочник.Пользователи";
	Обработчик.ИзменяемыеОбъекты = "Справочник.Пользователи";
	Обработчик.ПроцедураПроверки    = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	
КонецПроцедуры

// Блокирует пользователя в системе взаимодействия. 
// Если при блокировке были ошибки, то возвращается ИнформацияОбОшибке.
// Если пользователь заблокирован, то возвращается Неопределено.
//
// Параметры:
//    Пользователь - СправочникСсылка.Пользователь
//
// Возвращаемое значение:
//    ИнформацияОбОшибке, Неопределено
//
Функция ЗаблокироватьПользователяСистемыВзаимодействия(Пользователь) Экспорт
	Результат = Неопределено;
	
	ИдентификаторПользователяСВ = Неопределено;
	ШаблонЗаписиЖурналаРегистрации = НСтр("ru='Пользователь %1 недействителен. Пользователь системы взаимодействий заблокирован'");
		
	ИдентификаторПользователяИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяИБ");
	Если Не ЗначениеЗаполнено(ИдентификаторПользователяИБ) Тогда
		Возврат Результат;
	КонецЕсли;
	
	// АПК:280-выкл - При отсутствии пользователя система взаимодействия может выбросить исключение.
	Попытка
		ИдентификаторПользователяСВ = СистемаВзаимодействия.ПолучитьИдентификаторПользователя(
			ИдентификаторПользователяИБ);
	Исключение
		// Если выброшено исключение, то пользователя системы взаимодействия не удалось найти.
	КонецПопытки;
	// АПК:280-вкл
	
	Если ИдентификаторПользователяСВ = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;	
	
	Попытка
		ПользовательСВ = СистемаВзаимодействия.ПолучитьПользователя(ИдентификаторПользователяСВ);
		ПользовательСВ.Заблокирован = Истина;
		ПользовательСВ.Записать();
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(НСтр("ru='Блокировка недействительных пользователей'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Информация,,Пользователь,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаписиЖурналаРегистрации, Пользователь));
	Исключение
		Результат = ИнформацияОбОшибке();
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

// Возвращает массив пользователей, которые должны быть заблокированы в системе взаимодействия.
//
// Возвращаемое значение:
//    Массив из СправочникСсылка.Пользователи
//
Функция НедействительныеПользователи() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.Недействителен
	|	 ИЛИ Пользователи.ПометкаУдаления";
	Результат = Запрос.Выполнить().Выгрузить();
	МассивСсылок = Результат.ВыгрузитьКолонку("Ссылка");
	Возврат МассивСсылок;

КонецФункции

Процедура ПользователиДляБлокировкиВСистемеВзаимодействий(Параметры) Экспорт

	Если НЕ Подключены() Тогда
		Возврат;
	КонецЕсли;
	
	МассивСсылок = НедействительныеПользователи();
    ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаблокироватьНедействительныхПользователейВСистемеВзаимодействий(ПараметрыОбновления) Экспорт

	ПолноеИмяОбъектаМетаданных = "Справочник.Пользователи";
	ПользователиВыборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(ПараметрыОбновления.Очередь, ПолноеИмяОбъектаМетаданных);
			
	ОбъектыСОшибками = 0;
	ТекстПоследнейОшибки = "";
	Пока ПользователиВыборка.Следующий() Цикл
		Пользователь = ПользователиВыборка.Ссылка;
		ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Пользователь); // Если обработка будет неуспешной, то предусмотрено ручное исправление
 		Ошибка = ЗаблокироватьПользователяСистемыВзаимодействия(Пользователь);
		Если Ошибка <> Неопределено Тогда
			ОбъектыСОшибками = ОбъектыСОшибками + 1;
			ТекстПоследнейОшибки = ПодробноеПредставлениеОшибки(Ошибка);
		КонецЕсли;
	КонецЦикла;
	
	Если ОбъектыСОшибками > 0 Тогда
		
		ОшибкаЖурналаРегистрации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не удалось заблокировать пользователей в системе взаимодействия: %1.
					|Возможно, система взаимодействия временно недоступна.
					|Для блокировки нажмите ""Заблокировать недействительных в системе взаимодействия"" в подменю Еще списка пользователей.'") + Символы.ПС,
			ОбъектыСОшибками);

		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(НСтр("ru='Блокировка недействительных пользователей'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Предупреждение,,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОшибкаЖурналаРегистрации, ОбъектыСОшибками)
			+ Символы.ПС + ТекстПоследнейОшибки);
	
	КонецЕсли;
	
	ПараметрыОбновления.ОбработкаЗавершена = Истина;

КонецПроцедуры

Функция СобытиеЖурналаРегистрации(ДетализацияСобытия = "") Экспорт
	Возврат НСтр("ru='Обсуждения'", ОбщегоНазначения.КодОсновногоЯзыка())
		+ ?(ПустаяСтрока(ДетализацияСобытия), "", "."+ДетализацияСобытия);
КонецФункции

Процедура СоздатьИзменитьИнтеграцию(Параметры) Экспорт

	Идентификатор = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Идентификатор");
	Если Идентификатор <> Неопределено Тогда
		НоваяИнтеграция = Вычислить("СистемаВзаимодействия.ПолучитьИнтеграцию(Идентификатор)");
	Иначе
		НоваяИнтеграция = Вычислить("СистемаВзаимодействия.СоздатьИнтеграцию()");
	КонецЕсли;
	
	НоваяИнтеграция.ТипВнешнейСистемы = Параметры.Тип;
	НоваяИнтеграция.Представление = Параметры.Ключ;
	НоваяИнтеграция.Ключ = Параметры.Ключ;
	НоваяИнтеграция.Использование = Истина;
	ОписаниеВнешнейСистемы = Вычислить("СистемаВзаимодействия.ПолучитьОписаниеВнешнейСистемы(Параметры.Тип)");
	
	НеУказанныеПараметры = Новый Массив;
	Для каждого ПараметрИнтеграции Из ОписаниеВнешнейСистемы.ОписанияПараметров Цикл
		Если НЕ Параметры.Свойство(ПараметрИнтеграции.Имя) Тогда
			Если ПараметрИнтеграции.Обязательный Тогда
				НеУказанныеПараметры.Добавить(ПараметрИнтеграции.Имя);
			КонецЕсли;
		Иначе
			НоваяИнтеграция.ПараметрыВнешнейСистемы.Вставить(ПараметрИнтеграции.Имя, Параметры[ПараметрИнтеграции.Имя]);
		КонецЕсли;
	КонецЦикла;
	
	Если НеУказанныеПараметры.Количество() > 0 Тогда
		ВызватьИсключение НСтр("ru='Не заполнены параметры интеграции: 
			|%1'", СтрСоединить(НеУказанныеПараметры, Символы.ПС + "- "));
	КонецЕсли;
	
	НоваяИнтеграция.Участники.Очистить();
	Для каждого Участник Из Обсуждения.ПользователиСистемыВзаимодействия(Параметры.Участники) Цикл
	    Если Участник.Значение <> Неопределено Тогда
			НоваяИнтеграция.Участники.Добавить(Участник.Значение.Идентификатор);
		КонецЕсли;
	КонецЦикла;
	
	НоваяИнтеграция.Записать();
КонецПроцедуры

Процедура ОтключитьИнтеграцию(Идентификатор) Экспорт

	Интеграция = Вычислить("СистемаВзаимодействия.ПолучитьИнтеграцию(Идентификатор)");
	Интеграция.Использование = Ложь;
	Интеграция.Записать();

КонецПроцедуры

#КонецОбласти