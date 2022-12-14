///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПроверкаКонтрагентовВДокументах

// Определение вида документа.
//
// Параметры:
//  Форма								 - ФормаКлиентскогоПриложения - Форма документа, для которого необходимо получить описание.
//	Результат							 - Структура - Описывает вид документа. Ключи:
//  		"КонтрагентНаходитсяВШапке"			 	- Булево - Признак того, есть у документа контрагент в шапке
//  		"КонтрагентНаходитсяВТабличнойЧасти"	- Булево - Признак того, есть у документа контрагенты в табличных частях
//  		"СчетФактураНаходитсяВПодвале"		 	- Булево - Признак того, есть у документа счет-фактура в подвале
//  		"ЯвляетсяСчетомФактурой"				- Булево - Признак того, является ли сам документ счетом-фактурой.
//
// @skip-warning
Процедура ОпределитьВидДокумента(Форма, Результат) Экспорт
	
	
КонецПроцедуры

// Получение счета-фактуры, находящегося в подвале документа-основания, чья форма передана в качестве
//             параметра.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения - Форма документа-основания, для которой необходимо получить счет-фактуру.
//  СчетФактура	 - ДокументСсылка - Счет-фактура, полученная для данного документа-основания.
//
// @skip-warning
Процедура ПолучитьСчетФактуру(Форма, СчетФактура) Экспорт
	
	
КонецПроцедуры

// Возможность доопределить сформированную подсказку для формы документа.
//
// Параметры:
//  Результат            - Структура - содержит текст подсказки и цвет фона подсказки.
//  СостояниеКонтрагента - ПеречислениеСсылка.СостоянияСуществованияКонтрагента - текущее состояние контрагента.
//  Цвета                - Структура - содержит цвета, используемые при выводе информации о состоянии контрагента.
//
// @skip-warning
Процедура ПослеФормированияПодсказкиВДокументе(Результат, СостояниеКонтрагента, Цвета) Экспорт
	
	
	
КонецПроцедуры 

#КонецОбласти

#Область ПроверкаКонтрагентовВОтчетах

// Вывод панели проверки в отчете.
//
// Параметры:
//  Форма	 				- ФормаКлиентскогоПриложения - Форма отчета, для которого выводится результат проверки контрагента.
//  СостояниеПроверки		- Строка - Текущее состояние проверки, может принимать следующие значения, либо быть пустой
//                                строкой: ВсеКонтрагентыКорректные
// 			НайденыНекорректныеКонтрагенты
// 			ДопИнформацияПоПроверке
// 			ПроверкаВПроцессеВыполнения
// 			НетДоступаКСервису.
//  СтандартнаяОбработка	- Булево - Если Ложь, то игнорируется стандартное действие и выполняется указанное в данной
//                                  процедуре.
// @skip-warning
Процедура УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, СтандартнаяОбработка, СостояниеПроверки = "") Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВСправочнике

// Отображение результата проверки контрагента в справочнике.
// Реализация тела метода является обязательной.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма справочника, в котором выполнялась проверка контрагента.
//  	Результат проверки хранится в реквизите РеквизитыПроверкиКонтрагентов(Структура) формы контрагента.
//  	Структуру полей РеквизитыПроверкиКонтрагентов см. в процедуре ИнициализироватьРеквизитыФормыКонтрагент ОМ
//  	ПроверкаКонтрагентов.
//  ПредставлениеРезультатаПроверки	 - ФорматированнаяСтрока, Строка - представление результата проверки
//  					контрагента.
//
// @skip-warning
Процедура ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма, ПредставлениеРезультатаПроверки) Экспорт
	
	ПроверяемыеСостояния = Новый Массив;
	ПроверяемыеСостояния.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП"));
	ПроверяемыеСостояния.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентОтсутствуетВБазеФНС"));
	ПроверяемыеСостояния.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КППНеСоответствуетДаннымБазыФНС"));
	
	Если ПроверяемыеСостояния.Найти(Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента) <> Неопределено Тогда
		Форма.ПредставлениеРезультатПроверкиКонтрагента = ПредставлениеРезультатаПроверки;
	Иначе
		Форма.ПредставлениеРезультатПроверкиКонтрагента = Неопределено;
	КонецЕсли;
	
	СформироватьПредставлениеПроверкиДанных(Форма);
	
КонецПроцедуры

// Определяет строковое представление результата проверки контрагента.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма справочника, в котором выполнялась проверка контрагента.
//  	Результат проверки хранится в реквизите РеквизитыПроверкиКонтрагентов(Структура) формы контрагента.
//  	Структуру полей РеквизитыПроверкиКонтрагентов см. в процедуре ИнициализироватьРеквизитыФормыКонтрагент ОМ
//  	ПроверкаКонтрагентов.
//  Текст - Строка - представление результата проверки контрагента.
//
Процедура ПриЗаполненииТекстаРезультатаПроверки(Форма, Текст) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедуры

// Получение объекта (ДанныеФормыСтруктура) и ссылки(ДокументСсылка, СправочникСсылка) документа или
// справочника,  в котором выполняется проверка контрагента, по форме.
// Обязательна к заполнению.
//
// Параметры:
//	Форма     - ФормаКлиентскогоПриложения - Форма документа или справочника, в котором выполняется проверка контрагента.
//	Результат - Структура - Объект и Ссылка, полученные по форме документа.
//		Ключи: "Объект" (Тип ДанныеФормыСтруктура) и "Ссылка" (Тип ДокументСсылка, СправочникСсылка).
//
// @skip-warning
Процедура ПриОпределенииОбъектаИСсылкиПоФорме(Форма, Результат) Экспорт
	
	ИсточникОбъект = Форма.Объект;
	ИсточникСсылка = ИсточникОбъект.Ссылка;
	
	Результат.Вставить("Объект", ИсточникОбъект);
	Результат.Вставить("Ссылка", ИсточникСсылка);
	
КонецПроцедуры

// Возможность дополнить параметры запуска фонового задания при проверке справочника.
//
// Параметры:
//  ДополнительныеПараметрыЗапуска - Структура - содержит параметры запуска.
//  Форма                          - ФормаКлиентскогоПриложения - форма, из которой запускается фоновое задание.
//
// @skip-warning
Процедура ДополнитьПараметрыЗапускаФоновогоЗадания(ДополнительныеПараметрыЗапуска, Форма) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйИнтерфейсУНФ

Процедура СформироватьПредставлениеПроверкиДанных(Форма) Экспорт
	
	КомпонентыФС = Новый Массив;
	
	ПоказатьПроверкуКонтрагентаВСервисе = ПустаяСтрока(Форма.ПредставлениеПроверкиИНН) И ПустаяСтрока(Форма.ПредставлениеПроверкиКПП);
	
	Если ПоказатьПроверкуКонтрагентаВСервисе И НЕ ПустаяСтрока(Форма.ПредставлениеРезультатПроверкиКонтрагента) Тогда
		КомпонентыФС.Добавить(Форма.ПредставлениеРезультатПроверкиКонтрагента);
		КомпонентыФС.Добавить(Символы.ПС);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Форма.ПредставлениеПроверкиИНН) Тогда
		КомпонентыФС.Добавить(Форма.ПредставлениеПроверкиИНН);
		КомпонентыФС.Добавить(Символы.ПС);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Форма.ПредставлениеПроверкиКПП) Тогда
		КомпонентыФС.Добавить(Форма.ПредставлениеПроверкиКПП);
		КомпонентыФС.Добавить(Символы.ПС);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Форма.ПредставлениеПроверкиОКПО) Тогда
		КомпонентыФС.Добавить(Форма.ПредставлениеПроверкиОКПО);
		КомпонентыФС.Добавить(Символы.ПС);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Форма.ПредставлениеПроверкиОГРН) Тогда
		КомпонентыФС.Добавить(Форма.ПредставлениеПроверкиОГРН);
		КомпонентыФС.Добавить(Символы.ПС);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Форма.ПредставлениеПроверкиДублей) Тогда
		КомпонентыФС.Добавить(Форма.ПредставлениеПроверкиДублей);
		КомпонентыФС.Добавить(Символы.ПС);
	КонецЕсли;
	
	Если КомпонентыФС.Количество() > 0 Тогда
		КомпонентыФС.Удалить(КомпонентыФС.ВГраница());
	КонецЕсли;
	
	Форма.ПредставлениеПроверкиДанных = Новый ФорматированнаяСтрока(КомпонентыФС);
	Форма.Элементы.ПредставлениеПроверкиДанных.Видимость = Не ПустаяСтрока(Форма.ПредставлениеПроверкиДанных);
	Если Не ПустаяСтрока(Форма.ПредставлениеПроверкиДанных) Тогда
		Форма.Элементы.ПредставлениеПроверкиДанных.Высота = СтрЧислоСтрок(Форма.ПредставлениеПроверкиДанных);
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет КПП на базе ИНН
//
// Параметры
//  ИНН  - Строка - ИНН на основании которого будет сгенерирован КПП.
//  КПП  - Строка - КПП, текущий КПП контрагента.
//
Процедура ЗаполнитьКППпоИНН(Знач ИНН, КПП) Экспорт
	
	// Если КПП формируется стандартным образом по ИНН, то для КПП берутся 
	// первые 4 цифры ИНН + 01001, например:
	// ИНН 7712563009
	// КПП 771201001
	
	// Если не указано ИНН то прерываем выполнение операции
	Если (СтрДлина(ИНН) < 4) Тогда
		Возврат;
	КонецЕсли;
	
	КПП = Лев(ИНН, 4) + "01001";
	
КонецПроцедуры

#КонецОбласти