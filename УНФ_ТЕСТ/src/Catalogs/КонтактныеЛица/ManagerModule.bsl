#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоГруппа ИЛИ
	|	ЗначениеРазрешено(Ссылка)";

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

#КонецОбласти

// Возвращает список контрагентов, связанных с контактом
Функция СвязанныеКонтрагенты(Контакт) Экспорт
	
	Контрагенты = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(Контакт) Тогда
		Возврат Контрагенты;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.Ссылка КАК Ссылка
		|ИЗ
		|	РегистрСведений.СвязиКонтрагентКонтакт.СрезПоследних(, Контакт = &Контакт) КАК СвязиКонтрагентКонтактСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО (Контрагенты.Ссылка = СвязиКонтрагентКонтактСрезПоследних.Контрагент)
		|ГДЕ
		|	Контрагенты.ПометкаУдаления = ЛОЖЬ
		|	И СвязиКонтрагентКонтактСрезПоследних.СвязьНедействительна = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Контакт", Контакт);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Контрагенты.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат Контрагенты;
	
КонецФункции

// Получает ссылку на элемент справочника с переданными свойствами.
// Если элемент с таким набором свойств отсутствует в справочнике,
// он автоматически создается.
//
// Параметры:
//  - Владелец - Ссылка - ссылка на элемент-владелец
//  - ДанныеЗаполнения  - структура свойств, которыми должен обладать
//                        элемент справочника. Элементы структуры:
//    - Должность - Строка - должность контактного лица
//    - Фамилия   - Строка - фамилия контактного лица
//    - Имя       - Строка - имя контактного лица
//    - Отчество  - Строка - отчество контактного лица
//
// Возвращаемое значение:
//  - Ссылка - ссылка на элемент справочника
//
Функция ПолучитьЭлемент(Владелец, Наименование) Экспорт
	
	
	Результат = ПустаяСсылка();
	
	// Поиск существующего контактного лица
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Владелец",  Владелец);
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтактныеЛица.Ссылка
	|ИЗ
	|	Справочник.КонтактныеЛица КАК КонтактныеЛица
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СвязиКонтрагентКонтакт.СрезПоследних  КАК СвязиКонтрагентКонтакт
	|	ПО КонтактныеЛица.Ссылка = СвязиКонтрагентКонтакт.Контакт
	|		И СвязиКонтрагентКонтакт.Контрагент = &Владелец
	|	И КонтактныеЛица.Наименование = &Наименование";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	КонецЕсли;
	
	Если Результат.Пустая() Тогда
		НовоеКонтактноеЛицо = СоздатьЭлемент();
		НовоеКонтактноеЛицо.Наименование       = Наименование;
		НовоеКонтактноеЛицо.Записать();
		РегистрыСведений.СвязиКонтрагентКонтакт.НоваяСвязь(Владелец, НовоеКонтактноеЛицо);
		
		Результат = НовоеКонтактноеЛицо.Ссылка;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучателиЭлектронногоПисьма(КонтактноеЛицо, ВидКонтактнойИнформации = Неопределено) Экспорт
	
	ПолучателиЭлектронногоПисьма = Новый ТаблицаЗначений;
	ПолучателиЭлектронногоПисьма.Колонки.Добавить("Контакт", Метаданные.ОпределяемыеТипы.КонтактСобытия.Тип);
	ПолучателиЭлектронногоПисьма.Колонки.Добавить("КакСвязаться", Новый ОписаниеТипов("Строка"));
	
	КонтактнаяИнформацияОбъекта = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(КонтактноеЛицо, ВидКонтактнойИнформации,, Ложь);
	
	Если ВидКонтактнойИнформации = Неопределено Тогда
		ОтборКонтактнойИнформации = Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		СтрокиКонтактнойИнформации = КонтактнаяИнформацияОбъекта.НайтиСтроки(ОтборКонтактнойИнформации);
	Иначе
		СтрокиКонтактнойИнформации = КонтактнаяИнформацияОбъекта;
	КонецЕсли;
	
	Для каждого Строка Из СтрокиКонтактнойИнформации Цикл
		НовыйПолучатель = ПолучателиЭлектронногоПисьма.Добавить();
		НовыйПолучатель.Контакт = КонтактноеЛицо;
		НовыйПолучатель.КакСвязаться = Строка.Представление;
	КонецЦикла;
	
	Возврат ПолучателиЭлектронногоПисьма;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)

	Если Параметры.Свойство("Рекурсия") Тогда
		Возврат;
	КонецЕсли;

	Если Параметры.ВыборГруппИЭлементов <> ИспользованиеГруппИЭлементов.Группы Тогда

		Если Не Параметры.Отбор.Свойство("Недействителен") Тогда
			Параметры.Отбор.Вставить("Недействителен", Ложь);
		КонецЕсли;

	Иначе

		Для Каждого КлючИЗначение Из Параметры.Отбор Цикл
			НайденныйРеквизит = Метаданные.Справочники.КонтактныеЛица.Реквизиты.Найти(КлючИЗначение.Ключ);
			Если НайденныйРеквизит = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если НайденныйРеквизит.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляЭлемента Тогда
				Параметры.Отбор.Удалить(КлючИЗначение.Ключ);
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	Параметры.Вставить("Рекурсия");
	СтандартныйСписок = ПолучитьДанныеВыбора(Параметры);
	КонтрагентКонтакт = СоответствиеКонтрагентовИКонтактов(СтандартныйСписок.ВыгрузитьЗначения());

	Для Каждого ДанныеКонтакта Из СтандартныйСписок Цикл
		ДанныеКонтакта.Представление = ПредставлениеКонтакта(ДанныеКонтакта.Представление, ДанныеКонтакта.Значение,
			КонтрагентКонтакт);
	КонецЦикла;
	ДанныеВыбора = СтандартныйСписок;

КонецПроцедуры

#КонецОбласти

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ЗагрузкаДанныхИзВнешнегоИсточника

Процедура ДобавитьКИ(ЭлементСправочника, ПредставлениеКИ, ВидКИ)
	
	XMLПредставление = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(ПредставлениеКИ, ВидКИ);
	УправлениеКонтактнойИнформацией.ЗаписатьКонтактнуюИнформацию(ЭлементСправочника, XMLПредставление, ВидКИ, ВидКИ.Тип);
	
КонецПроцедуры

Процедура ПриОпределенииОбразцовЗагрузкиДанных(НастройкиЗагрузкиДанных, УникальныйИдентификатор) Экспорт
	
	Образец_xlsx = ПолучитьМакет("ОбразецЗагрузкиДанных_xlsx");
	ОбразецЗагрузкиДанных_xlsx = ПоместитьВоВременноеХранилище(Образец_xlsx, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_xlsx", ОбразецЗагрузкиДанных_xlsx);
	
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_mxl", "ОбразецЗагрузкиДанных_mxl");
	
	Образец_csv = ПолучитьМакет("ОбразецЗагрузкиДанных_csv");
	ОбразецЗагрузкиДанных_csv = ПоместитьВоВременноеХранилище(Образец_csv, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_csv", ОбразецЗагрузкиДанных_csv);
	
КонецПроцедуры

Процедура ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных) Экспорт
	
	//
	// Для группы полей действует правило: хотя бы одно поле в группе должно быть выбрано в колонках
	//
	
	ОписаниеТиповСтрока3 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(3));
	ОписаниеТиповСтрока9 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(9));
	ОписаниеТиповСтрока11 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(11));
	ОписаниеТиповСтрока25 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(25));
	ОписаниеТиповСтрока50 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(50));
	ОписаниеТиповСтрока100 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100));
	ОписаниеТиповСтрока150 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(150));
	ОписаниеТиповСтрока200 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(200));
	ОписаниеТиповСтрока250 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(250));
	ОписаниеТиповСтрока1024 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(1024));
	ОписаниеТиповСтрока0000 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(0));
	ОписаниеТиповДата = Новый ОписаниеТипов("Дата", , , , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.КонтактныеЛица");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Наименование","ФИО (наименование)",	ОписаниеТиповСтрока100, ОписаниеТиповКолонка, "Контакт", 1, Истина, Истина);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Код", 		"Код", 					ОписаниеТиповСтрока9, ОписаниеТиповКолонка, "Контакт", 2, , Истина);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Родитель", "Группа", ОписаниеТиповСтрока100, ОписаниеТиповКолонка, , , , );
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаКонтрагентов") Тогда
		
		ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.ГруппыДоступаКонтрагентов");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ГруппаДоступа", "Группа доступа", ОписаниеТиповСтрока200, ОписаниеТиповКолонка, , , Истина);
		
	КонецЕсли;
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Телефон", "Телефон", ОписаниеТиповСтрока100, ОписаниеТиповСтрока100);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "АдресЭП", "E-mail", ОписаниеТиповСтрока100, ОписаниеТиповСтрока100);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("ПеречислениеСсылка.ПолФизическогоЛица");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Пол", "Пол", ОписаниеТиповСтрока3, ОписаниеТиповКолонка);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ДатаРождения", "Дата рождения", ОписаниеТиповСтрока25, ОписаниеТиповДата);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ДокументУдостоверяющийЛичность", "Документ", ОписаниеТиповСтрока250, ОписаниеТиповСтрока250);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.ИсточникиПривлеченияПокупателей");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ИсточникПривлечения", "Источник привлечения", ОписаниеТиповСтрока100, ОписаниеТиповКолонка);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("Строка");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Комментарий", "Заметки", ОписаниеТиповСтрока0000, ОписаниеТиповКолонка);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ИНН_КПП1", 				"(1) ИНН/КПП или ИНН", 				ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Контрагент_1", 1);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Контрагент1Наименование",	"(1) Контрагент (наименование)",	ОписаниеТиповСтрока100, ОписаниеТиповКолонка, "Контрагент_1", 2);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "РасчетныйСчет1",			"(1) Контрагент (расчетный счет)",	ОписаниеТиповСтрока50, ОписаниеТиповКолонка, "Контрагент_1", 3);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Должность1", 				"(1) Должность (роль)", 			ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Контрагент_1", 4);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ИНН_КПП2", 				"(2) ИНН/КПП или ИНН", 				ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Контрагент_2", 1);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Контрагент2Наименование",	"(2) Контрагент (наименование)",	ОписаниеТиповСтрока100, ОписаниеТиповКолонка, "Контрагент_2", 2);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "РасчетныйСчет2",			"(2) Контрагент (расчетный счет)",	ОписаниеТиповСтрока50, ОписаниеТиповКолонка, "Контрагент_2", 3);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Должность2", 				"(2) Должность (роль)", 			ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Контрагент_2", 4);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ИНН_КПП3", 				"(3) ИНН/КПП или ИНН", 				ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Контрагент_3", 1);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Контрагент3Наименование",	"(3) Контрагент (наименование)",	ОписаниеТиповСтрока100, ОписаниеТиповКолонка, "Контрагент_3", 2);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "РасчетныйСчет3",			"(3) Контрагент (расчетный счет)",	ОписаниеТиповСтрока50, ОписаниеТиповКолонка, "Контрагент_3", 3);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Должность3", 				"(3) Должность (роль)", 			ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Контрагент_3", 4);
	
	// ДополнительныеРеквизиты
	ЗагрузкаДанныхИзВнешнегоИсточника.ПодготовитьСоответствиеПоДополнительнымРеквизитам(НастройкиЗагрузкиДанных, Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_КонтактныеЛица);
	Если НастройкиЗагрузкиДанных.ОписаниеДополнительныхРеквизитов.Количество() > 0 Тогда
		
		ИмяПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяПоляДобавленияДополнительныхРеквизитов();
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, ИмяПоля, "Дополнительные реквизиты", ОписаниеТиповСтрока150, ОписаниеТиповСтрока11, , , , , , Истина, Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_КонтактныеЛица);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанныеИзВнешнегоИсточника(ПараметрыСопоставления, АдресРезультата) Экспорт
	
	ТаблицаСопоставленияДанных	= ПараметрыСопоставления.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных			= ТаблицаСопоставленияДанных.Количество();
	НастройкиЗагрузкиДанных		= ПараметрыСопоставления.НастройкиЗагрузкиДанных;
	ОбновлятьДанные				= НастройкиЗагрузкиДанных.ОбновлятьСуществующие;
	
	// ТаблицаСопоставленияДанных - Тип ДанныеФормыКоллекция
	Для каждого СтрокаТаблицыФормы Из ТаблицаСопоставленияДанных Цикл
		
		// Номенклатура по ШтрихКоду, Артикулу, Наименованию, НаименованиеПолное
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьКонтактноеЛицо(СтрокаТаблицыФормы.Контакт, СтрокаТаблицыФормы.Наименование, СтрокаТаблицыФормы.Код);
		ЭтаСтрокаСопоставлена = ЗначениеЗаполнено(СтрокаТаблицыФормы.Контакт);
		
		// Родитель по наименованию
		ЗначениеПоУмолчанию = Справочники.КонтактныеЛица.ПустаяСсылка();
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьРодителя("КонтактныеЛица", СтрокаТаблицыФормы.Родитель, СтрокаТаблицыФормы.Родитель_ВходящиеДанные, ЗначениеПоУмолчанию);
		
		// Группа доступа
		Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаКонтрагентов") Тогда
			
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьГруппуДоступа(СтрокаТаблицыФормы.ГруппаДоступа, СтрокаТаблицыФормы.ГруппаДоступа_ВходящиеДанные);
			
		КонецЕсли;
		
		// КИ (адрес ЭП, телефон)
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.АдресЭП, СтрокаТаблицыФормы.АдресЭП_ВходящиеДанные);
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.Телефон, СтрокаТаблицыФормы.Телефон_ВходящиеДанные);
		
		// Пол
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьПолФизическогоЛица(СтрокаТаблицыФормы.Пол, СтрокаТаблицыФормы.Пол_ВходящиеДанные);
		
		// Дата рождения
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВДату(СтрокаТаблицыФормы.ДатаРождения, СтрокаТаблицыФормы.ДатаРождения_ВходящиеДанные);
		
		// Документ удостоверяющий личность
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.ДокументУдостоверяющийЛичность, СтрокаТаблицыФормы.ДокументУдостоверяющийЛичность_ВходящиеДанные);
		
		// Источник привлечения
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьИсточникиПривлеченияПокупателей(СтрокаТаблицыФормы.ИсточникПривлечения, СтрокаТаблицыФормы.ИсточникПривлечения_ВходящиеДанные);
		
		// Комментарий
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.Комментарий, СтрокаТаблицыФормы.Комментарий_ВходящиеДанные);
		
		// (1) Контрагент по ИНН, КПП, Наименованию, Расчетному счету
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьКонтрагента(СтрокаТаблицыФормы.Контрагент_1, СтрокаТаблицыФормы.ИНН_КПП1, СтрокаТаблицыФормы.Контрагент1Наименование, СтрокаТаблицыФормы.РасчетныйСчет1);
		
		// (2) Контрагент по ИНН, КПП, Наименованию, Расчетному счету
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьКонтрагента(СтрокаТаблицыФормы.Контрагент_2, СтрокаТаблицыФормы.ИНН_КПП2, СтрокаТаблицыФормы.Контрагент2Наименование, СтрокаТаблицыФормы.РасчетныйСчет2);
		
		// (3) Контрагент по ИНН, КПП, Наименованию, Расчетному счету
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьКонтрагента(СтрокаТаблицыФормы.Контрагент_3, СтрокаТаблицыФормы.ИНН_КПП3, СтрокаТаблицыФормы.Контрагент3Наименование, СтрокаТаблицыФормы.РасчетныйСчет3);
		
		// Дополнительные реквизиты
		Если НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты.Количество() > 0 Тогда
			
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьДополнительныеРеквизиты(СтрокаТаблицыФормы, НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты);
			
		КонецЕсли;
		
		ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы);
		
		ЗагрузкаДанныхИзВнешнегоИсточника.ПрогрессСопоставленияДанных(ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицыФормы), РазмерТаблицыДанных);
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТаблицаСопоставленияДанных, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	
	СтрокаТаблицыФормы._СтрокаСопоставлена = ЗначениеЗаполнено(СтрокаТаблицыФормы.Контакт);
	
	ИмяСлужебногоПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна();
	
	СтрокаТаблицыФормы[ИмяСлужебногоПоля] = СтрокаТаблицыФормы._СтрокаСопоставлена
											ИЛИ (НЕ СтрокаТаблицыФормы._СтрокаСопоставлена И НЕ ПустаяСтрока(СтрокаТаблицыФормы.Наименование));
	
КонецПроцедуры

Процедура ОбработатьПодготовленныеДанные(СтруктураДанных, ФоновоеЗаданиеАдресХранилища = "") Экспорт
	
	ТекущийПользователь				= Пользователи.АвторизованныйПользователь();
	НастройкиОбновленияСвойств		= СтруктураДанных.НастройкиЗагрузкиДанных.НастройкиОбновленияСвойств;
	ОбновлятьСуществующие			= СтруктураДанных.НастройкиЗагрузкиДанных.ОбновлятьСуществующие;
	СоздаватьЕслиНеСопоставлено		= СтруктураДанных.НастройкиЗагрузкиДанных.СоздаватьЕслиНеСопоставлено;
	ТаблицаСопоставленияДанных		= СтруктураДанных.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных				= ТаблицаСопоставленияДанных.Количество();
	КоличествоЗаписейТранзакции		= 0;
	ТранзакцияОткрыта				= Ложь;
	
	Попытка
		
		Для каждого СтрокаТаблицы Из ТаблицаСопоставленияДанных Цикл
			
			Если НЕ ТранзакцияОткрыта 
				И КоличествоЗаписейТранзакции = 0 Тогда
				
				НачатьТранзакцию();
				ТранзакцияОткрыта = Истина;
				
			КонецЕсли;
			
			ЗагрузкаВПриложениеВозможна = СтрокаТаблицы[ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна()];
			
			СогласованноеСостояниеСтроки = (СтрокаТаблицы._СтрокаСопоставлена И ОбновлятьСуществующие) 
				ИЛИ (НЕ СтрокаТаблицы._СтрокаСопоставлена И СоздаватьЕслиНеСопоставлено);
				
			Если ЗагрузкаВПриложениеВозможна И СогласованноеСостояниеСтроки Тогда
				
				КоличествоЗаписейТранзакции = КоличествоЗаписейТранзакции + 1;
				
				Если СтрокаТаблицы._СтрокаСопоставлена Тогда
					
					ЭлементСправочника = СтрокаТаблицы.Контакт.ПолучитьОбъект();
					ЗаполнитьЗначенияСвойств(ЭлементСправочника, СтрокаТаблицы, НастройкиОбновленияСвойств.ИменаПолейОбновляемые, НастройкиОбновленияСвойств.ИменаПолейНеподлежащихОбновлению);
					
				Иначе
					
					ЭлементСправочника = Справочники.КонтактныеЛица.СоздатьЭлемент();
					ЗаполнитьЗначенияСвойств(ЭлементСправочника, СтрокаТаблицы);
					
					ЭлементСправочника.ДатаСоздания = ТекущаяДатаСеанса();
					ЭлементСправочника.Родитель = СтрокаТаблицы.Родитель;
					
				КонецЕсли;
				
				ЭлементСправочника.Наименование = СтрокаТаблицы.Наименование;
				
				Если НЕ ПустаяСтрока(СтрокаТаблицы.Телефон) Тогда
					
					ДобавитьКИ(ЭлементСправочника, СтрокаТаблицы.Телефон, Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица);
					
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(СтрокаТаблицы.АдресЭП) Тогда
					
					ДобавитьКИ(ЭлементСправочника, СтрокаТаблицы.АдресЭП, Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица);
					
				КонецЕсли;
				
				Если СтруктураДанных.НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты.Количество() > 0 Тогда
					
					ЗагрузкаДанныхИзВнешнегоИсточника.ОбработатьВыбранныеДополнительныеРеквизиты(ЭлементСправочника, СтрокаТаблицы._СтрокаСопоставлена, СтрокаТаблицы, СтруктураДанных.НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты);
					
				КонецЕсли;
				
				ЭлементСправочника.Записать();
				
				Если ЗначениеЗаполнено(СтрокаТаблицы.Контрагент_1) Тогда
					
					РегистрыСведений.СвязиКонтрагентКонтакт.НоваяСвязь(СтрокаТаблицы.Контрагент_1, ЭлементСправочника.Ссылка, СтрокаТаблицы.Должность1,ТекущийПользователь,);
					
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаТаблицы.Контрагент_2) Тогда
					
					РегистрыСведений.СвязиКонтрагентКонтакт.НоваяСвязь(СтрокаТаблицы.Контрагент_2, ЭлементСправочника.Ссылка, СтрокаТаблицы.Должность2, ТекущийПользователь,);
					
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаТаблицы.Контрагент_3) Тогда
					
					РегистрыСведений.СвязиКонтрагентКонтакт.НоваяСвязь(СтрокаТаблицы.Контрагент_3, ЭлементСправочника.Ссылка, СтрокаТаблицы.Должность3, ТекущийПользователь,);
					
				КонецЕсли;
				
			КонецЕсли;
			
			ИндексТекущейстроки = ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицы);
			ТекстПрогресса      = СтрШаблон(НСтр("ru ='Обработано %1 из %2 строк...'"), ИндексТекущейстроки, РазмерТаблицыДанных);
			ПроцентВыполнения   = Окр(ИндексТекущейстроки * 100 / РазмерТаблицыДанных);
			
			ДлительныеОперации.СообщитьПрогресс(ПроцентВыполнения, ТекстПрогресса);
			
			Если ТранзакцияОткрыта
				И КоличествоЗаписейТранзакции > ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.МаксимумЗаписейВОднойТранзакции() Тогда
				
				ЗафиксироватьТранзакцию();
				ТранзакцияОткрыта = Ложь;
				КоличествоЗаписейТранзакции = 0;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТранзакцияОткрыта 
			И КоличествоЗаписейТранзакции > 0 Тогда
			
			ЗафиксироватьТранзакцию();
			ТранзакцияОткрыта = Ложь;
			
		КонецЕсли;
		
	Исключение
		
		ЗаписьЖурналаРегистрации(Нстр("ru='Загрузка данных'"), УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.Номенклатура, , ОписаниеОшибки());
		ОтменитьТранзакцию();
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ШаблоныСообщений

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения
//         ** Имя            - Строка - Уникальное имя вложения.
//         ** Представление  - Строка - Представление варианта.
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl"
//                                      и др.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
	
	
КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура - структура с ключами:
//    * ЗначенияРеквизитов - Соответствие - список используемых в шаблоне реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие - список используемых в шаблоне общих реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие - значения реквизитов 
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище вложения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ДополнительныеПараметры - Структура -  Дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, ПредметСообщения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений - список получается SMS.
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS.
//     * Представление - Строка - представление получателя сообщения SMS.
//     * Контакт       - Произвольный - контакт, которому принадлежит номер телефона.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.//
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Заполняет список получателей письма при отправки сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма.
//     * Адрес           - Строка - адрес электронной почты получателя.
//     * Представление   - Строка - представление получается письма.
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электрнной почты.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//                                              если шаблон содержит произвольные параметры:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область КонтактнаяИнформацияУНФ

Процедура ЗаполнитьДанныеПанелиКонтактнаяИнформация(ВладелецКИ, ДанныеПанелиКонтактнойИнформации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтактнаяИнформация.Ссылка КАК Ссылка,
	|	КонтактнаяИнформация.Тип КАК Тип,
	|	КонтактнаяИнформация.Вид КАК Вид,
	|	КонтактнаяИнформация.Представление КАК Представление,
	|	КонтактнаяИнформация.ЗначенияПолей КАК ЗначенияПолей,
	|	КонтактнаяИнформация.Значение КАК Значение
	|ИЗ
	|	Справочник.КонтактныеЛица.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Ссылка = &ВладелецКИ";
	
	Запрос.УстановитьПараметр("ВладелецКИ", ВладелецКИ);
	ДанныеКИ = Запрос.Выполнить().Выбрать();
	
	Пока ДанныеКИ.Следующий() Цикл
		НоваяСтрока = ДанныеПанелиКонтактнойИнформации.Добавить();
		Комментарий = УправлениеКонтактнойИнформацией.КомментарийКонтактнойИнформации(ДанныеКИ.Значение);
		НоваяСтрока.Отображение = Строка(ДанныеКИ.Вид) + ": " + ДанныеКИ.Представление + ?(ПустаяСтрока(Комментарий), "", ", " + Комментарий);
		НоваяСтрока.ИндексПиктограммы = КонтактнаяИнформацияПанельУНФ.ИндексПиктограммыПоТипу(ДанныеКИ.Тип);
		НоваяСтрока.ТипОтображаемыхДанных = "ЗначениеКИ";
		НоваяСтрока.ВладелецКИ = ВладелецКИ;
		НоваяСтрока.ПредставлениеКИ = ДанныеКИ.Представление;
		НоваяСтрока.ТипКИ = ДанныеКИ.Тип;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает список имен «ключевых» реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	
	РедактируемыеРеквизиты.Добавить("ГруппаДоступа");
	РедактируемыеРеквизиты.Добавить("ДатаСоздания");
	РедактируемыеРеквизиты.Добавить("Недействителен");
	РедактируемыеРеквизиты.Добавить("Ответственный");
	РедактируемыеРеквизиты.Добавить("ИсточникПривлечения");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

// Возвращает таблицу контрагентов , которые связаны с контактами
//
Функция СоответствиеКонтрагентовИКонтактов(Контакты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Контрагенты.Представление КАК Представление,
	|	СвязиКонтрагентКонтакт.Контакт КАК Контакт
	|ИЗ
	|	РегистрСведений.СвязиКонтрагентКонтакт.СрезПоследних КАК СвязиКонтрагентКонтакт
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО (Контрагенты.Ссылка = СвязиКонтрагентКонтакт.Контрагент)
	|ГДЕ
	|	СвязиКонтрагентКонтакт.Контакт В(&Контакты)
	|	И СвязиКонтрагентКонтакт.СвязьНедействительна = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Контакты", Контакты);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает апедставление контакта, со списком связанных с ним контрагентов черзе запятую
//
Функция ПредставлениеКонтакта(ПредставлениеЭлемента, Контакт, КонтрагентКонтакт)
	
	Контрагенты = КонтрагентКонтакт.НайтиСтроки(Новый Структура("Контакт", Контакт));
	
	СтрокаКонтрагентов = Новый Массив;
	Для Каждого Контрагент Из Контрагенты Цикл
		СтрокаКонтрагент = Строка(Контрагент.Представление);
		СтрокаКонтрагентов.Добавить(СтрокаКонтрагент);
	КонецЦикла;
	
	ПредставлениеКонтрагентов = ?(СтрокаКонтрагентов.Количество()>0, "(Контрагенты: " + СтрСоединить(СтрокаКонтрагентов, ", "), "(<нет связей>") + ")";
	ПредставлениеКонтакта = Новый ФорматированнаяСтрока(ПредставлениеЭлемента," ", ПредставлениеКонтрагентов);
	
	Возврат ПредставлениеКонтакта;
	
КонецФункции

#КонецОбласти

#КонецЕсли