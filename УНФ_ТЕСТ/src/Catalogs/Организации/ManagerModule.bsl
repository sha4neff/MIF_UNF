#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
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

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Префикс");
	Результат.Добавить("КонтактнаяИнформация.*");
	
	Возврат Результат
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Использование нескольких организаций.

// Возвращает организацию назначенную компанией.
//
Функция ОрганизацияКомпания() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Компания.Значение КАК Значение
	|ИЗ
	|	Константа.Компания КАК Компания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО Компания.Значение = Организации.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Значение;
	Иначе
		Возврат Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Возвращает организацию по умолчанию.
// Если в ИБ есть только одна организация, которая не помечена на удаление и не является предопределенной,
// то будет возвращена ссылка на нее, иначе будет возвращена пустая ссылка.
//
// Возвращаемое значение:
//     СправочникСсылка.Организации - ссылка на организацию.
//
Функция ОрганизацияПоУмолчанию() Экспорт
	
	Организация = Справочники.Организации.ПустаяСсылка();
	
	ОрганизацияКомпании = ОрганизацияКомпания();
	ПользовательскаяНастройкаОсновнойОрганизации = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.АвторизованныйПользователь(), "ОсновнаяОрганизация");
	Если ЗначениеЗаполнено(ОрганизацияКомпании) Тогда
		
		Организация = ОрганизацияКомпании;
		
	ИначеЕсли ЗначениеЗаполнено(ПользовательскаяНастройкаОсновнойОрганизации) Тогда
		
		Организация = ПользовательскаяНастройкаОсновнойОрганизации;
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
		|	Организации.Ссылка КАК Организация
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	НЕ Организации.ПометкаУдаления";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
			Организация = Выборка.Организация;
		Иначе
			Попытка 
				Возврат Справочники.Организации.ОсновнаяОрганизация;
			Исключение
				// если предопределённый элемент отсутствует в данных
				Возврат Организация;
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Организация;

КонецФункции

// Возвращает количество элементов справочника Организации.
// Не учитывает предопределенные и помеченные на удаление элементы.
//
// Возвращаемое значение:
//     Число - количество организаций.
//
Функция КоличествоОрганизаций() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Количество = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = Выборка.Количество;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Количество;
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РеквизитыОрганизации";
	КомандаПечати.Представление = НСтр("ru = 'Реквизиты'");
	КомандаПечати.СписокФорм = "ФормаЭлемента,ФормаСписка";
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Печать реквизитов организации'");
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ПолучитьФункциональнуюОпцию("ЭтоМобильноеПриложение") Тогда
		Если ВидФормы = "ФормаОбъекта" Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаЭлементаМобильныйИнтерфейс";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает систему налогообложения организации.
// Параметры: 
//   Дата - Дата
//   Организация - СправочникСсылка.Организации
// Возвращаемое значение:
//   Структура с ключами:
//   Дата - дата применения системы налогообложения.
//   СистемаНалогообложения - ПеречислениеСсылка.СистемыНалогообложения
Функция ПолучитьСистемуНалогообложения(Дата, Организация) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СистемыНалогообложения.СистемаНалогообложения,
	|	СистемыНалогообложения.Период КАК Дата
	|ИЗ
	|	РегистрСведений.СистемыНалогообложенияОрганизаций.СрезПоследних(&Дата, Организация = &Организация) КАК СистемыНалогообложения");
	
	Запрос.УстановитьПараметр("Дата",  Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Новый Структура("Дата, СистемаНалогообложения", Выборка.Дата, Выборка.СистемаНалогообложения);
		
	Иначе
		
		Возврат Новый Структура("Дата, СистемаНалогообложения", "00010101", Перечисления.СистемыНалогообложения.ПустаяСсылка()); 
		
	КонецЕсли;
	
КонецФункции

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

#Область ИнтерфейсПечати

// Процедура формирования макета печати
//
Функция СформироватьПомощникРаботыФаксимильнойПечати(МасиивОрганизаций, ОбъектыПечати, ИмяМакета)
	
	ТабличныйДокумент	= Новый ТабличныйДокумент;
	Макет				= УправлениеПечатью.МакетПечатнойФормы("Справочник.Организации." + ИмяМакета);
	
	Для каждого Организация Из МасиивОрганизаций Цикл 
	
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ПоляКЗаполнению"));
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Линия"));
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Схема"));
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 1, ОбъектыПечати, Организация);
	
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;

КонецФункции // СформироватьПомощникРаботыФаксимильнойПечати()

Функция УниверсальныйЗапросПоДаннымДокумента(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаДокумента",						ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Номер", 								"00000000001");
	Запрос.УстановитьПараметр("Организация", 						МассивОбъектов[0]);
	Запрос.УстановитьПараметр("ОрганизацияЮридическоеФизическоеЛицо",МассивОбъектов[0].ЮридическоеФизическоеЛицо);
	Запрос.УстановитьПараметр("Префикс", 							МассивОбъектов[0].Префикс);
	Запрос.УстановитьПараметр("БанковскийСчет",						МассивОбъектов[0].БанковскийСчетПоУмолчанию);
	Запрос.УстановитьПараметр("ФайлЛоготип",						МассивОбъектов[0].ФайлЛоготип);
	Запрос.УстановитьПараметр("ФайлФаксимильнаяПечать",				МассивОбъектов[0].ФайлФаксимильнаяПечать);
	Запрос.УстановитьПараметр("ДолжностьРуководителя",				МассивОбъектов[0].ПодписьРуководителя.Должность);
	Запрос.УстановитьПараметр("РасшифровкаПодписиРуководителя", 	МассивОбъектов[0].ПодписьРуководителя.РасшифровкаПодписи);
	Запрос.УстановитьПараметр("ФаксимилеПодписиРуководителя", 		МассивОбъектов[0].ПодписьРуководителя.Факсимиле);
	Запрос.УстановитьПараметр("РуководительДолжность",				МассивОбъектов[0].ПодписьРуководителя.Должность);
	Запрос.УстановитьПараметр("РуководительРасшифровкаПодписи", 	МассивОбъектов[0].ПодписьРуководителя.РасшифровкаПодписи);
	Запрос.УстановитьПараметр("РуководительФаксимилеПодписи", 		МассивОбъектов[0].ПодписьРуководителя.Факсимиле);
	Запрос.УстановитьПараметр("ГлавныйБухгалтерДолжность",			МассивОбъектов[0].ПодписьГлавногоБухгалтера.Должность);
	Запрос.УстановитьПараметр("ГлавныйБухгалтерРасшифровкаПодписи", МассивОбъектов[0].ПодписьГлавногоБухгалтера.РасшифровкаПодписи);
	Запрос.УстановитьПараметр("ГлавныйБухгалтерФаксимиле", 			МассивОбъектов[0].ПодписьГлавногоБухгалтера.Факсимиле);
	Запрос.УстановитьПараметр("ВалютаДокумента",					Константы.НациональнаяВалюта.Получить());
	Запрос.УстановитьПараметр("Договор", 							НСтр("ru ='Договор № 000001 от 30.12.1922'"));
	Запрос.УстановитьПараметр("ОснованиеПечати", 					НСтр("ru ='Договор № 000001 от 30.12.1922'"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Организация КАК Ссылка
	|	,&ДатаДокумента КАК ДатаДокумента
	|	,&Номер КАК Номер
	|	,&Организация КАК Организация
	|	,&ОрганизацияЮридическоеФизическоеЛицо КАК ОрганизацияЮридическоеФизическоеЛицо
	|	,&Префикс КАК Префикс
	|	,&БанковскийСчет КАК БанковскийСчет
	|	,&ФайлЛоготип КАК ФайлЛоготип
	|	,&ФайлФаксимильнаяПечать КАК ФаксимилеПечати
	|	,Неопределено КАК Подразделение
	|	,Значение(Перечисление.ДаНет.Да) КАК ИспользоватьФаксимиле
	|	,&РуководительДолжность КАК ДолжностьРуководителя
	|	,&РуководительРасшифровкаПодписи КАК РасшифровкаПодписиРуководителя
	|	,&РуководительРасшифровкаПодписи КАК РасшифровкаПодписиВыполнилРаботыУслуги
	|	,&РуководительФаксимилеПодписи КАК ФаксимилеРуководителя
	|	,&ГлавныйБухгалтерДолжность КАК ДолжностьГлавногоБухгалтера
	|	,&ГлавныйБухгалтерРасшифровкаПодписи КАК РасшифровкаПодписиГлавногоБухгалтера
	|	,&ГлавныйБухгалтерФаксимиле КАК ФаксимилеГлавногоБухгалтера
	|	,Истина КАК СуммаВключаетНДС
	|	,&ВалютаДокумента КАК ВалютаДокумента
	|	,Неопределено КАК Контрагент
	|	,&Договор КАК Договор
	|	,Неопределено КАК ДополнительныеУсловия
	|	,Неопределено КАК ДокументОснование
	|	,Неопределено КАК Ответственный
	|	,Неопределено КАК ФизическоеЛицоОтветственного
	|	,Неопределено КАК Автор
	|	,Неопределено КАК ДисконтнаяКарта
	|	,Неопределено КАК ПроцентСкидкиПоДисконтнойКарте
	|	,Неопределено КАК Комментарий
	|	,&ОснованиеПечати КАК ОснованиеПечати
	|	,Неопределено КАК ОснованиеПечатиСсылка
	|	,Неопределено КАК ТаблицаЗапасы
	|	,Неопределено КАК ТаблицаПланаОплат
	|	,ЛОЖЬ КАК ОжидаетсяВыборВариантаКП";
	
	ТаблицаСчета = Запрос.Выполнить().Выгрузить();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	1 КАК НомерСтроки
	|	,""Запас для предварительного просмотра"" КАК ПредставлениеНоменклатуры
	|	,Неопределено КАК Характеристика
	|	,""АРТ-0000001"" КАК Артикул
	|	,""0000000001"" КАК Код
	|	,""шт."" КАК ЕдиницаИзмерения
	|	,118 КАК Цена
	|	,118 КАК Сумма
	|	,18 КАК СуммаНДС
	|	,118 КАК Всего
	|	,1 КАК Количество
	|	,Неопределено КАК Содержание
	|	,0 КАК ПроцентСкидкиНаценки
	|	,0 КАК ЕстьСкидка
	|	,0 КАК СуммаАвтоматическойСкидки
	|	,ЛОЖЬ КАК ЭтоРазделитель
	|	,ЛОЖЬ КАК ЭтоНабор
	|	,ЛОЖЬ КАК НеобходимоВыделитьКакСоставНабора
	|	,ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК НоменклатураНабора
	|	,ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ХарактеристикаНабора";
	
	ТаблицаСчета[0].ТаблицаЗапасы = Запрос.Выполнить().Выгрузить();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	0 КАК ПроцентОплаты
	|	,0 КАК СуммаОплаты
	|	,0 КАК СуммаНДСОплаты";
	
	ТаблицаСчета[0].ТаблицаПланаОплат = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаСчета;
	
КонецФункции

// Процедура формирования табличного документа с реквизитами организаций
//
Функция ПечатьКарточкиОрганизации(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Организация_КарточкаОрганизации";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.Организации.РеквизитыОрганизации");
	Разделитель = Макет.ПолучитьОбласть("Разделитель");
	
	ТекДата = ТекущаяДатаСеанса();
	ПервыйДокумент = Истина;
	
	Для каждого Организация Из МассивОбъектов Цикл
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.Вывести(Разделитель);
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		ЭтоЮрЛицо = Организация.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
		
		СведенияОбОрганизации = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(Организация, ТекДата);
		
		Область = Макет.ПолучитьОбласть("Наименование");
		Область.Параметры.ПолноеНаименование = СведенияОбОрганизации.ПолноеНаименование;
		ТабличныйДокумент.Вывести(Область);
		
		Если ЗначениеЗаполнено(СведенияОбОрганизации.ИНН) Тогда
			Область = Макет.ПолучитьОбласть("ИНН");
			Область.Параметры.ИНН = СведенияОбОрганизации.ИНН;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		
		Если ЭтоЮрЛицо И ЗначениеЗаполнено(СведенияОбОрганизации.КПП) Тогда
			Область = Макет.ПолучитьОбласть("КПП");
			Область.Параметры.КПП = СведенияОбОрганизации.КПП;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СведенияОбОрганизации.КодПоОКПО) Тогда
			Область = Макет.ПолучитьОбласть("ОКПО");
			Область.Параметры.КодПоОКПО = СведенияОбОрганизации.КодПоОКПО;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СведенияОбОрганизации.НомерСчета) 
			И ЗначениеЗаполнено(СведенияОбОрганизации.БИК) 
			И ЗначениеЗаполнено(СведенияОбОрганизации.КоррСчет) 
			И ЗначениеЗаполнено(СведенияОбОрганизации.Банк) Тогда
			
			Область = Макет.ПолучитьОбласть("РасчетныйСчет");
			Область.Параметры.НомерСчета = СведенияОбОрганизации.НомерСчета;
			Область.Параметры.БИК = СведенияОбОрганизации.БИК;
			Область.Параметры.КоррСчет = СведенияОбОрганизации.КоррСчет;
			Область.Параметры.Банк = СведенияОбОрганизации.Банк;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СведенияОбОрганизации.ЮридическийАдрес) 
			ИЛИ ЗначениеЗаполнено(СведенияОбОрганизации.Телефоны) Тогда
			ТабличныйДокумент.Вывести(Разделитель);
		КонецЕсли;
		
		Если ЭтоЮрЛицо И ЗначениеЗаполнено(СведенияОбОрганизации.ЮридическийАдрес) Тогда
			Область = Макет.ПолучитьОбласть("ЮридическийАдрес");
			Область.Параметры.ЮридическийАдрес = СведенияОбОрганизации.ЮридическийАдрес;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
			
		Если Не ЭтоЮрЛицо И ЗначениеЗаполнено(СведенияОбОрганизации.ЮридическийАдрес) Тогда
			Область = Макет.ПолучитьОбласть("АдресИП");
			Область.Параметры.АдресИП = СведенияОбОрганизации.ЮридическийАдрес;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
			
		Если ЗначениеЗаполнено(СведенияОбОрганизации.Телефоны) Тогда
			Область = Макет.ПолучитьОбласть("Телефон");
			Область.Параметры.Телефон = СведенияОбОрганизации.Телефоны;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		
		Если Не ЭтоЮрЛицо
			И СведенияОбОрганизации.Свойство("СвидетельствоСерияНомер") И ЗначениеЗаполнено(СведенияОбОрганизации.СвидетельствоСерияНомер)
			И СведенияОбОрганизации.Свойство("СвидетельствоДатаВыдачи") И ЗначениеЗаполнено(СведенияОбОрганизации.СвидетельствоДатаВыдачи) Тогда
			
			Область = Макет.ПолучитьОбласть("Свидетельство");
			Область.Параметры.СвидетельствоСерияНомер = СведенияОбОрганизации.СвидетельствоСерияНомер;
			Область.Параметры.СвидетельствоДатаВыдачи = Формат(СведенияОбОрганизации.СвидетельствоДатаВыдачи, "ДЛФ=D");
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		
		Если ЭтоЮрЛицо 
			И ЗначениеЗаполнено(Организация.ПодписьРуководителя) Тогда
			
			Область = Макет.ПолучитьОбласть("Руководитель");
			Область.Параметры.Должность = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ПодписьРуководителя.Должность");
			Область.Параметры.РасшифровкаПодписи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ПодписьРуководителя.РасшифровкаПодписи");
			
			ТабличныйДокумент.Вывести(Область);
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Организация);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ОбъектыПечати         – СписокЗначений   – значение – ссылка на объект
//                                            - представление – имя области в которой был выведен объект
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РеквизитыОрганизации") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"РеквизитыОрганизации",
			НСтр("ru='Реквизиты организации'"),
			ПечатьКарточкиОрганизации(МассивОбъектов, ОбъектыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НапечататьПомощникСозданияФаксимилеПечати") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"НапечататьПомощникСозданияФаксимилеПечати",
			НСтр("ru='Как быстро и просто создать факсимиле печати?'"),
			СформироватьПомощникРаботыФаксимильнойПечати(МассивОбъектов, ОбъектыПечати, "ПомощникСозданияФаксимилеПечати"));
		
	КонецЕсли;
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ПредварительныйПросмотрПечатнойФормыСчетНаОплату");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		ПечатнаяФорма.ТабличныйДокумент.КлючПараметровПечати = Обработки.ПечатьСчетНаОплату.КлючПараметровПечати();
		ПечатнаяФорма.ПолныйПутьКМакету = Обработки.ПечатьСчетНаОплату.ПолныйПутьКМакету();
		ПечатнаяФорма.СинонимМакета = Обработки.ПечатьСчетНаОплату.ПредставлениеПФ(Ложь);
		
		ДанныеОбъектовПечати = УниверсальныйЗапросПоДаннымДокумента(МассивОбъектов);
		Обработки.ПечатьСчетНаОплату.СформироватьПФ(ПечатнаяФорма, ДанныеОбъектовПечати, ОбъектыПечати, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел()
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ГруппаДел = НСтр("ru = 'ЭДО'");
	
	// Сервис 1С-ЭДО в режиме сервиса не работает
	Если РаботаВМоделиСервиса.РазделениеВключено()
		Или ТекущиеДелаСервер.ДелоОтключено(ГруппаДел) Тогда
		
		Возврат;
	КонецЕсли;
	
	СпособыОЭД = Новый Массив;
	СпособыОЭД.Добавить(Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО);
	ВключенОбменЭД = ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭД");
	ЕстьПравоНастройкиЭДО = УправлениеНебольшойФирмойУправлениеДоступомПовтИсп.ЕстьПравоНастройкиЭДО();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка КАК Организация,
		|	Организации.Наименование КАК Наименование
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	НомерПоПорядку = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Если ОбменСКонтрагентами.ОрганизацияПодключена(Выборка.Организация) Тогда
			Продолжить;
		КонецЕсли;
		
		НомерПоПорядку = НомерПоПорядку + 1;
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор	 = "ПодключениеЭДО_" + НомерПоПорядку;
		Дело.ЕстьДела		= Истина;
		Дело.Важное			= Ложь;
		Дело.Представление	= НСтр("ru='Подключиться к 1С-ЭДО'") + ", " + Выборка.Наименование;
		Дело.Количество		= 0;
		Дело.Владелец		= ГруппаДел;
		
		Если ВключенОбменЭД Тогда
			
			Если ЕстьПравоНастройкиЭДО Тогда
				Дело.Форма			= "РегистрСведений.УчетныеЗаписиЭДО.Форма.ПомощникПодключенияЭДО";
				Дело.ПараметрыФормы = Новый Структура("Организация,СпособыОбменаЭД", Выборка.Организация, СпособыОЭД);
				Дело.Подсказка	= НСтр("ru='Подключиться к 1С-ЭДО (обмену электронными документами)'") + ", " + Выборка.Наименование;
			Иначе
				Дело.Форма			= "";
				Дело.ПараметрыФормы = Новый Структура;
				Дело.Подсказка	= НСтр("ru='Недостаточно прав для настройки обмена электронными документами. Обратитесь к администратору.'");
			КонецЕсли;
			
		ИначеЕсли Пользователи.ЭтоПолноправныйПользователь() Тогда
			
			Дело.Форма			= "Обработка.ПанельАдминистрированияЭДО.Форма.ОбменЭлектроннымиДокументами";
			Дело.ПараметрыФормы = Новый Структура;
			Дело.Подсказка	= НСтр("ru='Необходимо включить обмен электронными документами с контрагентами.'");
			
		Иначе
			
			Дело.Форма			= "";
			Дело.ПараметрыФормы = Новый Структура;
			Дело.Подсказка	= НСтр("ru='Для включения возможности обмена электронными документами с контрагентами обратитесь к администратору.'");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОбновления

Процедура ЗаполнитьВидыСтавокНДС(Параметры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтавкиНДС.Ссылка КАК Ссылка,
	|	СтавкиНДС.ВидСтавкиНДС КАК ВидСтавкиНДС
	|ПОМЕСТИТЬ ВТСТАВКИ
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Ссылка КАК Ссылка,
	|	СправочникСтавки.ВидСтавкиНДС КАК ВидСтавкиНДС
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСТАВКИ КАК СправочникСтавки
	|		ПО (СправочникСтавки.Ссылка = Организации.УдалитьСтавкаНДСПоУмолчанию)
	|ГДЕ
	|	Организации.УдалитьСтавкаНДСПоУмолчанию <> ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)
	|	И Организации.ВидСтавкиНДСПоУмолчанию = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.ПустаяСсылка)
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ЕстьОшибки = Ложь;
	
	Пока Выборка.Следующий() Цикл
		
		ОрганизацииОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ОрганизацииОбъект.ВидСтавкиНДСПоУмолчанию = Выборка.ВидСтавкиНДС;
		ОрганизацииОбъект.ДополнительныеСвойства.Вставить("ОбновлениеВидовСтавокНДС");
		
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОрганизацииОбъект);
		Исключение
			ЕстьОшибки = Истина;
			ТекстСообщения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации("ru='Ошибка заполнения вида ставки НДС'",
				УровеньЖурналаРегистрации.Ошибка,,
				ОрганизацииОбъект.Ссылка,
				ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Если Параметры <> Неопределено Тогда
		Параметры.ОбработкаЗавершена = НЕ ЕстьОшибки И Выборка.Количество() < 1000;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
