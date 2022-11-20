///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет состав назначений и общие реквизиты в шаблонах сообщений 
//
// Параметры:
//  Настройки - Структура:
//    * ПредметыШаблонов - ТаблицаЗначений - содержит варианты предметов для шаблонов. Колонки:
//         ** Имя           - Строка - уникальное имя назначения.
//         ** Представление - Строка - представление варианта.
//         ** Макет         - Строка - имя макета СКД, если состав реквизитов определяется посредством СКД.
//         ** ЗначенияПараметровСКД - Структура - значения параметров СКД для текущего предмета шаблона сообщения.
//    * ОбщиеРеквизиты - ДеревоЗначений - содержит описание общих реквизитов доступных во всех шаблонах. Колонки:
//         ** Имя            - Строка - уникальное имя общего реквизита.
//         ** Представление  - Строка - представление общего реквизита.
//         ** Тип            - Тип    - тип общего реквизита. По умолчанию строка.
//    * ИспользоватьПроизвольныеПараметры  - Булево - указывает, можно ли использовать произвольные пользовательские
//                                                    параметры в шаблонах сообщений.
//    * ЗначенияПараметровСКД - Структура - общие значения параметров СКД, для всех макетов, где состав реквизитов
//                                          определяется средствами СКД.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.ИспользоватьПроизвольныеПараметры = Истина;
	Настройки.РасширенныйСписокПолучателей = Истина;
	
	Для Каждого ПредметШаблона Из Настройки.ПредметыШаблонов Цикл
		Если СтрНайти(ПредметШаблона.Имя, "Документ") > 0 Тогда
			ПредметШаблона.Макет = "СКД_ДанныеШаблонаСообщений";
		КонецЕсли;
		Если ПредметШаблона.Имя = Метаданные.Документы.ЗаказПокупателя.ПолноеИмя()
			И ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуРаботы") Тогда
			
			ПредметШаблона.Представление = НСтр("ru='Заказ покупателя (заказ-наряд)'");
		КонецЕсли;
	КонецЦикла;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБиллинг") Тогда
		Предмет = Настройки.ПредметыШаблонов.Добавить();
		Предмет.Имя = "ДоговорыКонтрагентов";
		Предмет.Представление = НСтр("ru='Договор обслуживания'");
		Предмет.Макет = "СКД_ДанныеШаблонаСообщений";
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммы") Тогда
		Предмет = Настройки.ПредметыШаблонов.Добавить();
		Предмет.Имя = "НачислениеСписаниеБонусов";
		Предмет.Представление = НСтр("ru = 'Начисление/списание бонусов'");
		Предмет.Макет = "СКД_ДанныеШаблонаСообщений";
	КонецЕсли;
	
	ОтключаемыеПредметыПоФО = Новый Соответствие;
	ОтключаемыеПредметыПоФО.Вставить(Метаданные.Документы.ЗаказНаПроизводство.ПолноеИмя(), "ИспользоватьПодсистемуПроизводство");
	ОтключаемыеПредметыПоФО.Вставить(Метаданные.Документы.ПриемИПередачаВРемонт.ПолноеИмя(), "ИспользоватьРемонты");
	ОтключаемыеПредметыПоФО.Вставить(Метаданные.Справочники.РабочиеМеста.ПолноеИмя(), "ИспользоватьПодключаемоеОборудование");
	
	Для каждого ПроверяемыйПредмет Из ОтключаемыеПредметыПоФО Цикл
		Если ПолучитьФункциональнуюОпцию(ПроверяемыйПредмет.Значение) Тогда
			Продолжить;
		КонецЕсли;
		Предмет = Настройки.ПредметыШаблонов.Найти(ПроверяемыйПредмет.Ключ, "Имя");
		Если Предмет <> Неопределено Тогда
			Настройки.ПредметыШаблонов.Удалить(Предмет);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты - ДеревоЗначений - список реквизитов шаблона:
//    * Имя            - Строка - уникальное имя общего реквизита;
//    * Представление  - Строка - представление общего реквизита;
//    * Тип            - Тип    - тип реквизита. По умолчанию строка;
//    * Подсказка      - Строка - расширенная информация о реквизите;
//    * Формат         - Строка - формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения - ТаблицаЗначений - печатные формы и вложения, где:
//    * Имя           - Строка - уникальное имя вложения;
//    * Идентификатор - Строка - идентификатор вложения;
//    * Представление - Строка - представление варианта;
//    * Подсказка     - Строка - расширенная информация о вложении;
//    * ТипФайла      - Строка - тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl" и др.
//  НазначениеШаблона       - Строка  - имя назначения шаблон сообщения.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщения.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, НазначениеШаблона, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.РазворачиватьСсылочныеРеквизиты = Ложь;
	
	Если НазначениеШаблона = "ДоговорыКонтрагентов" Тогда
		
		ШаблоныСообщений.СформироватьСписокРеквизитовПоСКД(Реквизиты, Справочники.ДоговорыКонтрагентов.ПолучитьМакет("СКД_ДанныеШаблонаСообщений"));
		
		// Счет на оплату
		МетаданныеОбъекта = Документы.СчетНаОплату.ПустаяСсылка().Метаданные();
		Описание = Новый Структура("ОписаниеТипа, Представление");
		Описание.ОписаниеТипа = Новый ОписаниеТипов("ДокументСсылка.СчетНаОплату");
		Описание.Представление = МетаданныеОбъекта.Представление();
		ДополнительныеПараметры.Параметры.Вставить(МетаданныеОбъекта.Имя, Описание);
		
		// Акт выполненных работ
		МетаданныеОбъекта = Документы.АктВыполненныхРабот.ПустаяСсылка().Метаданные();
		Описание = Новый Структура("ОписаниеТипа, Представление");
		Описание.ОписаниеТипа = Новый ОписаниеТипов("ДокументСсылка.АктВыполненныхРабот");
		Описание.Представление = МетаданныеОбъекта.Представление();
		ДополнительныеПараметры.Параметры.Вставить(МетаданныеОбъекта.Имя, Описание);
	КонецЕсли;
	
	Если НазначениеШаблона = "НачислениеСписаниеБонусов" Тогда
		ШаблоныСообщений.СформироватьСписокРеквизитовПоСКД(Реквизиты, Справочники.ДисконтныеКарты.ПолучитьМакет("СКД_ДанныеШаблонаСообщений"));
	КонецЕсли;
	
	ИсключаемыеВложения = Новый Массив;
	Для каждого Вложение Из Вложения Цикл
		Если НЕ УправлениеНебольшойФирмойСервер.КомандаПечатаетсяВСерверномКонтексте(Вложение, "Имя") Тогда
			ИсключаемыеВложения.Добавить(Вложение);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Вложение Из ИсключаемыеВложения Цикл
		Вложения.Удалить(Вложение);
	КонецЦикла;
	
	ИнтеграцияСЯндексКассой.ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, НазначениеШаблона, ДополнительныеПараметры);
	Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, НазначениеШаблона, ДополнительныеПараметры);
	ДополнительныеПараметры.Вставить("ФорматыРеквизитов", Новый Соответствие);
	
КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура:
//    * ЗначенияРеквизитов - Соответствие - список используемых в шаблоне реквизитов:
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие - список используемых в шаблоне общих реквизитов:
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие:
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные
//                  - Строка - двоичные данные или адрес во временном хранилище вложения.
//    * ДополнительныеПараметры - Структура - дополнительные параметры сообщения. 
//  НазначениеШаблона - Строка -  полное имя назначения шаблон сообщения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ПараметрыШаблона - Структура -  дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона) Экспорт
	
	ИнтеграцияСЯндексКассой.ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона);
	РаботаСБонусами.ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона);
	Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона);
	
	ПривестиЗначенияРеквизитовКЗаданнымФорматам(Сообщение, ПараметрыШаблона);
	
	ЗаполнитьНомерДокумента(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона);
	
КонецПроцедуры

// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений:
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS;
//     * Представление - Строка - представление получателя сообщения SMS;
//     * Контакт       - Произвольный - контакт, которому принадлежит номер телефона.
//  НазначениеШаблона - Строка - идентификатор назначения шаблона
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект, являющийся источником данных.
//                   - Структура  - структура описывающая параметры шаблона:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект, являющийся источником данных;
//    * ВидСообщения - Строка - вид формируемого сообщения: "ЭлектроннаяПочта" или "СообщениеSMS";
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров;
//    * ОтправитьСразу - Булево - признак мгновенной отправки;
//    * ПараметрыСообщения - Структура - дополнительные параметры сообщения.
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, НазначениеШаблона, ПредметСообщения) Экспорт
	
	Предмет = ПредметСообщения;
	ВыбранныйПолучатель = Неопределено;
	ВыбранныйВидКИ = Неопределено;
	
	Если ТипЗнч(ПредметСообщения) = Тип("Структура") Тогда
		ПредметСообщения.Свойство("Предмет", Предмет);
		ПредметСообщения.ПараметрыСообщения.Свойство("ВыбранныйПолучатель", ВыбранныйПолучатель);
		ПредметСообщения.ПараметрыСообщения.Свойство("ВыбранныйВидКИ", ВыбранныйВидКИ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВыбранныйПолучатель) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьВыбранногоПолучателя(ПолучателиSMS, Предмет, ВыбранныйПолучатель, Перечисления.ТипыКонтактнойИнформации.Телефон, ВыбранныйВидКИ);
	
КонецПроцедуры

// Заполняет список получателей почты при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма:
//     * Адрес           - Строка - адрес электронной почты получателя;
//     * Представление   - Строка - представление получателя письма;
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электронной почты.
//  НазначениеШаблона - Строка - идентификатор назначения шаблона.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект, являющийся источником данных.
//                   - Структура  - структура описывающая параметры шаблона:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект, являющийся источником данных;
//    * ВидСообщения - Строка - вид формируемого сообщения: "ЭлектроннаяПочта" или "СообщениеSMS";
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров;
//    * ОтправитьСразу - Булево - признак мгновенной отправки письма;
//    * ПараметрыСообщения - Структура - дополнительные параметры сообщения;
//    * ПреобразовыватьHTMLДляФорматированногоДокумента - Булево - признак преобразование HTML текста
//             сообщения содержащего картинки в тексте письма из-за особенностей вывода изображений
//             в форматированном документе;
//    * УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись для отправки письма.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, НазначениеШаблона, ПредметСообщения) Экспорт
	
	Предмет = ПредметСообщения;
	ВыбранныйПолучатель = Неопределено;
	ВыбранныйВидКИ = Неопределено;
	
	Если ТипЗнч(ПредметСообщения) = Тип("Структура") Тогда
		ПредметСообщения.Свойство("Предмет", Предмет);
		ПредметСообщения.ПараметрыСообщения.Свойство("ВыбранныйПолучатель", ВыбранныйПолучатель);
		ПредметСообщения.ПараметрыСообщения.Свойство("ВыбранныйВидКИ", ВыбранныйВидКИ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Предмет) Тогда
		Возврат;
	КонецЕсли;
	
	ПолучателиПисьма.Очистить();
	
	Если ЗначениеЗаполнено(ВыбранныйПолучатель) Тогда
		ЗаполнитьВыбранногоПолучателя(ПолучателиПисьма, Предмет, ВыбранныйПолучатель, Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты, ВыбранныйВидКИ);
	Иначе
		ЗаполнитьПолучателейПоУмолчанию(ПолучателиПисьма, Предмет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйИнтерфейсУНФ

// Добавляет актуальные адреса почты или номера телефонов из контактной информации объекта в список получателей.
// В выборку адресов почты или номеров телефонов попадают только актуальные сведения, 
// т.к. нет смысла отправлять письма или сообщения SMS на архивные данные. 
//
// Параметры:
//  ПолучателиПисьма        - ТаблицаЗначений - Список получателей письма или сообщения SMS
//  ПредметСообщения        - Произвольный - Объект-родитель, у которого есть реквизиты, содержащие контактной информацию.
//  ИмяРеквизита            - Строка - Имя реквизита в объекте-родителе, из которого следует получить адреса почты или
//                                     номера телефонов.
//  ТипКонтактнойИнформации - ПеречислениеСсылка.ТипыКонтактнойИнформации - Если тип Адрес, то будут добавлены адреса
//                                                                          почта, если Телефон, то номера телефонов.
//
Процедура ЗаполнитьВыбранногоПолучателя(ПолучателиПисьма, ПредметСообщения, ИмяРеквизита, ТипКонтактнойИнформации, ВидКонтактнойИнформации) Экспорт
	
	ПолучательИзОбъекта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредметСообщения, ИмяРеквизита);
	Если ПолучательИзОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПолучательИзОбъекта) = Тип("СправочникСсылка.Сотрудники") Тогда
		ПолучательИзОбъекта = РегистрыСведений.СотрудникиПользователя.ПолучитьПользователяПоСотруднику(ПолучательИзОбъекта);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПолучательИзОбъекта) Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектыКонтактнойИнформации = Новый Массив;
	ОбъектыКонтактнойИнформации.Добавить(ПолучательИзОбъекта);
	
	КонтактнойИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(ОбъектыКонтактнойИнформации, ТипКонтактнойИнформации, ВидКонтактнойИнформации, ТекущаяДатаСеанса());
	Для каждого ЭлементКонтактнойИнформации Из КонтактнойИнформация Цикл
		Получатель = ПолучателиПисьма.Добавить();
		Если ТипКонтактнойИнформации = УправлениеКонтактнойИнформацией.ТипКонтактнойИнформацииПоНаименованию("Телефон") Тогда
			Получатель.НомерТелефона = ЭлементКонтактнойИнформации.Представление;
			Получатель.Представление = Строка(ЭлементКонтактнойИнформации.Объект);
			Получатель.Контакт       = ОбъектыКонтактнойИнформации[0];
		Иначе
			Получатель.Адрес         = ЭлементКонтактнойИнформации.Представление;
			Получатель.Представление = Строка(ЭлементКонтактнойИнформации.Объект);
			Получатель.Контакт       = ОбъектыКонтактнойИнформации[0];
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПолучателейПоУмолчанию(ПолучателиПисьма, ПредметСообщения) Экспорт
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Получатель", Новый Массив);
	УправлениеНебольшойФирмойСервер.ЗаполнитьПараметрыОтправки(
		ПараметрыОтправки,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПредметСообщения),
		Неопределено
	);
	
	Для Каждого Получатель Из ПараметрыОтправки.Получатель Цикл
		ПолучательПисьма = ПолучателиПисьма.Добавить();
		ПолучательПисьма.Адрес         = Получатель.Адрес;
		ПолучательПисьма.Представление = Строка(Получатель.Представление);
		ПолучательПисьма.Контакт       = Получатель.Представление;
	КонецЦикла;
	
КонецПроцедуры

Функция ЕстьДоступныеШаблоны(ДляПисем, Предмет = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ШаблоныСообщений.Ссылка
		|ИЗ
		|	Справочник.ШаблоныСообщений КАК ШаблоныСообщений
		|ГДЕ
		|	ШаблоныСообщений.ПредназначенДляЭлектронныхПисем = ИСТИНА
		|	И ШаблоныСообщений.Назначение <> ""Служебный""
		|	И ШаблоныСообщений.ПометкаУдаления = ЛОЖЬ";
	
	Если Не ДляПисем Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ШаблоныСообщений.ПредназначенДляЭлектронныхПисем", "ШаблоныСообщений.ПредназначенДляSMS");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Предмет) Тогда
		Запрос.Текст = Запрос.Текст + " И (ШаблоныСообщений.ПредназначенДляВводаНаОсновании = ЛОЖЬ ИЛИ ШаблоныСообщений.ПолноеИмяТипаПараметраВводаНаОсновании = &ПолноеИмяТипаПредмета)";
		ПолноеИмяТипаОснования = Предмет.Метаданные().ПолноеИмя();
		Запрос.УстановитьПараметр("ПолноеИмяТипаПредмета", ПолноеИмяТипаОснования);
	Иначе 
		Запрос.Текст = Запрос.Текст + " И ШаблоныСообщений.ПредназначенДляВводаНаОсновании = ЛОЖЬ";
	КонецЕсли;
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция НовыйУникальныйИдентификаторВложенияHTML() Экспорт
	
	ИдентификаторКартинки = Строка(Новый УникальныйИдентификатор);
	ИдентификаторКартинки = "_" + СтрЗаменить(ИдентификаторКартинки, "-", "_");
	
	Возврат ИдентификаторКартинки;
	
КонецФункции

// Создает шаблон сообщения.
//
// Параметры:
//  НаименованиеШаблона	 - Строка
//  ПараметрыШаблона	 - Стуктура - См. ШаблоныСообщенийПереопределяемый.ОписаниеПараметровШаблона()
//  КомандыПечати		 - Массив - Уникальные идентификаторы выбранных печатных форм.
//  Вложения			 - Массив
// 
// Возвращаемое значение:
//   -  Справочники.ШаблоныСообщений
//
Функция СоздатьШаблонEmail(НаименованиеШаблона, ПараметрыШаблона, КомандыПечати = Неопределено, Вложения = Неопределено) Экспорт
	
	ИмяСобытияЖР = НСтр("ru='Шаблоны сообщений: создание поставляемых шаблонов УНФ'");
	
	НачатьТранзакцию();
	Попытка
		НовыйШаблон = ШаблоныСообщений.СоздатьШаблон(НаименованиеШаблона, ПараметрыШаблона);
		
		Если КомандыПечати <> Неопределено Тогда
			НовыйШаблонОбъект = НовыйШаблон.ПолучитьОбъект();
			Для каждого КомандаПечати Из КомандыПечати Цикл
				Строка = НовыйШаблонОбъект.ПечатныеФормыИВложения.Добавить();
				Строка.Идентификатор = КомандаПечати;
			КонецЦикла;
			НовыйШаблонОбъект.Записать();
		КонецЕсли;
		
		Если Вложения <> Неопределено Тогда
			Для каждого Вложение Из Вложения Цикл
				СсылкаНаДвоичныеДанные = Вложение.СсылкаНаДвоичныеДанные;
				Вложение.ВладелецФайлов = НовыйШаблон;
				Вложение.Удалить("СсылкаНаДвоичныеДанные");
				
				Попытка
					НовыйФайл = РаботаСФайлами.ДобавитьФайл(Вложение, СсылкаНаДвоичныеДанные);
					Если НовыйФайл <> Неопределено Тогда
						ПрисоединенныйФайлОбъект = НовыйФайл.ПолучитьОбъект();
						ПрисоединенныйФайлОбъект.ИДФайлаЭлектронногоПисьма = Вложение.ИмяБезРасширения;
						ПрисоединенныйФайлОбъект.Записать();
					КонецЕсли;
				Исключение
					ИнформацияОбОшибке = ИнформацияОбОшибке();
					ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
					// Исключение может произойти в случае хранения файлов в томах, которые недоступны в момент обновления.
					// В таком случае продолжить запись шаблона без вложенных файлов.
				КонецПопытки;
			КонецЦикла;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОписаниеОшибки = ОписаниеОшибки();
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки);
		ВызватьИсключение ОписаниеОшибки;
	КонецПопытки;
	
	Возврат НовыйШаблон;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПривестиЗначенияРеквизитовКЗаданнымФорматам(Сообщение, ПараметрыШаблона)
	
	Если НЕ ПараметрыШаблона.Свойство("ФорматыРеквизитов") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ФорматРеквизита Из ПараметрыШаблона.ФорматыРеквизитов Цикл
		ПолученноеЗначение = Сообщение.ЗначенияРеквизитов.Получить(ФорматРеквизита.Ключ);
		Если ПолученноеЗначение <> Неопределено Тогда
			Сообщение.ЗначенияРеквизитов.Вставить(ФорматРеквизита.Ключ, Формат(ПолученноеЗначение, ФорматРеквизита.Значение));
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНомерДокумента(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона)
	
	Если ПредметСообщения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТипыПредметовСообщения = Метаданные.ОпределяемыеТипы.ПредметШаблонаСообщения.Тип;
	Если НЕ ТипыПредметовСообщения.СодержитТип(ТипЗнч(ПредметСообщения)) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.ЭтоДокумент(ПредметСообщения.Метаданные()) Тогда
		Возврат;
	КонецЕсли;
	
	Если Сообщение.ЗначенияРеквизитов.Получить("Номер") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НомерДокументаНаПечать = НомерДокументаНаПечать(ПредметСообщения);
	Если НомерДокументаНаПечать <> Неопределено Тогда
		Сообщение.ЗначенияРеквизитов.Вставить("Номер", НомерДокументаНаПечать);
	КонецЕсли;
	
КонецПроцедуры

Функция НомерДокументаНаПечать(ДокументСсылка)
	
	Если НЕ ЗначениеЗаполнено(ДокументСсылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МетаданныеДокумента = ДокументСсылка.Метаданные();
	Если НЕ ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", МетаданныеДокумента) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "Дата,Номер,Организация");
	ПрефиксОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		ДанныеДокумента.Организация,
		"Префикс");
	
	Возврат ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(
		ДанныеДокумента.Дата, ДанныеДокумента.Номер, ПрефиксОрганизации);
	
КонецФункции

#КонецОбласти
