
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект); // для проверки внедрения БСП
	Если Параметры.Ключ.Пустая() Тогда
		КонтактнаяИнформацияУНФ.ПриСозданииПриЧтенииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = УправлениеСвойствамиПереопределяемый.ЗаполнитьДополнительныеПараметры(Объект,
		"ДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриСозданииНаСервере(ЭтотОбъект, Объект.Наименование);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
	АвтоподборКонтактов.ПодключитьОбработчикиСобытияАвтоподбор(ЭтотОбъект);
	
	Параметры.Свойство("КлассификаторДляЗаполненияКИ", КлассификаторДляЗаполненияКИ);
	Если ЗначениеЗаполнено(КлассификаторДляЗаполненияКИ)
		И Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьНаименованиеИКонтактнуюИнформацию(КлассификаторДляЗаполненияКИ);
	КонецЕсли;
	
	Если Параметры.ОшибкиЗаполнения Тогда
		ПроверкаДанных.ВывестиСообщенияОбОшибкахЗаполнения("Объект", Параметры.ПереченьОшибок);
	КонецЕсли;
	
	ПолучитьАктуальныйДокументФизЛица();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка)
		И ЗначениеЗаполнено(КлассификаторДляЗаполненияКИ) Тогда
		ОповеститьОВыборе(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	ИначеЕсли ИмяСобытия = "ИзменилсяДокументФизЛиц" Тогда
		ПолучитьАктуальныйДокументФизЛица();
	ИначеЕсли ИмяСобытия = "УстановкаОсновногоСчета" И Параметр.Владелец = Объект.Ссылка Тогда
		Объект.БанковскийСчетПоУмолчанию = Параметр.НовыйОсновнойСчет;
		Если НЕ Модифицированность Тогда
			Записать();
		КонецЕсли;
		Оповестить("УстановкаОсновногоСчетаВыполнена");
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект); // для проверки внедрения БСП
	КонтактнаяИнформацияУНФ.ПриСозданииПриЧтенииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("СправочникФизическиеЛицаЗапись");
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект); // для проверки внедрения БСП
	КонтактнаяИнформацияУНФ.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриЗаписиФормыОбъектаСклонения(
		ЭтотОбъект,
		Объект.Наименование,
		ТекущийОбъект.Ссылка,
		ПараметрыСклоненияФИО(ТекущийОбъект));
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ФизическиеЛица", Объект.Ссылка)
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ); // для проверки
	// внедрения БСП
	КонтактнаяИнформацияУНФ.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставление(
		ЭтаФорма, Объект.Наименование, ПараметрыСклоненияФИО(Объект));
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	// УНФ Автоподбор контактов
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ОписаниеОповещения") Тогда
		СтандартнаяОбработка = Ложь;
		ВыполнитьОбработкуОповещения(ВыбранноеЗначение);
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КлассификаторКонтактов") Тогда
		СтандартнаяОбработка = Ложь;
		ЗаполнитьНаименованиеИКонтактнуюИнформацию(ВыбранноеЗначение);
	КонецЕсли;
	// Конец УНФ автоподбор контактов
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	АвтоподборКонтактовКлиент.НаименованиеАвтоПодбор(ЭтотОбъект, Элемент.Имя, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставление(
		ЭтаФорма, Объект.Наименование, ПараметрыСклоненияФИО(Объект));
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Объект.Ссылка.Пустая() Тогда
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Записать'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Отмена'"));
		Оповещение = Новый ОписаниеОповещения("ОбработкаОповещенияПереходаКДокументам", ЭтотОбъект);
		
		ПоказатьВопрос(
			Оповещение,
			НСтр("ru='Переход к заполнению сведений документов возможен только после записи.
				|Записать?'"),
			СписокКнопок);
		
		Записать();
		Возврат;
	КонецЕсли;
	Если НЕ Объект.Ссылка.Пустая() Тогда
		оп = Новый ОписаниеОповещения("ОповещениеЗаполненияДокумента", ЭтотОбъект);
		ОткрытьФорму("РегистрСведений.ДокументыФизическихЛиц.Форма.ФормаЗаполненияСведений",Новый Структура("ФизЛицо", Объект.Ссылка),,,,,оп, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьДополнительныйРеквизит(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийНаборСвойств", ПредопределенноеЗначение("Справочник.НаборыДополнительныхРеквизитовИСведений.Справочник_ФизическиеЛица"));
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Ложь);
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНаименованиеИКонтактнуюИнформацию(КлассификаторСсылка)
	
	ДанныеКонтакта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
	КлассификаторСсылка,
	"Title, JSON");
	
	Объект.Наименование = ДанныеКонтакта.Title;
	
	Объект.КонтактнаяИнформация.Очистить();
	
	Справочники.КлассификаторКонтактов.ЗаполнитьКонтактнуюИнформациюИзJSON(
	Объект.КонтактнаяИнформация,
	ДанныеКонтакта.JSON,
	ТипЗнч(Объект.Ссылка));
	
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьАктуальныйДокументФизЛица()
	
	Документ = РегистрыСведений.ДокументыФизическихЛиц.ПолучитьПредставлениеДокументаПоФизЛицу(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияПереходаКДокументам(Результат,Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Записать();
	Иначе
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		оп = Новый ОписаниеОповещения("ОповещениеЗаполненияДокумента", ЭтотОбъект);
		ОткрытьФорму("РегистрСведений.ДокументыФизическихЛиц.Форма.ФормаЗаполненияСведений",Новый Структура("ФизЛицо", Объект.Ссылка),,,,,оп, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполненияДокумента(Результат, Параметры) Экспорт
	ПолучитьАктуальныйДокументФизЛица();
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыСклоненияФИО(Объект)
	
	Если Объект.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской") Тогда
		ПолФизическогоЛицаЧислом = 1;
	ИначеЕсли Объект.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Женский") Тогда
		ПолФизическогоЛицаЧислом = 2;
	Иначе
		ПолФизическогоЛицаЧислом = Неопределено;
	КонецЕсли;
	
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ПараметрыСклонения.ЭтоФИО = Истина;
	Если ПолФизическогоЛицаЧислом <> Неопределено Тогда
		ПараметрыСклонения.Пол = ПолФизическогоЛицаЧислом;
	КонецЕсли;
	
	Возврат ПараметрыСклонения;
	
КонецФункции

#КонецОбласти

#Область КонтактнаяИнформацияУНФ

&НаСервере
Процедура ДобавитьКонтактнуюИнформациюСервер(ДобавляемыйВид, УстановитьВыводВФормеВсегда = Ложь) Экспорт
	
	КонтактнаяИнформацияУНФ.ДобавитьКонтактнуюИнформацию(ЭтотОбъект, ДобавляемыйВид, УстановитьВыводВФормеВсегда);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ДействиеКИНажатие(Элемент)
	
	КонтактнаяИнформацияУНФКлиент.ДействиеКИНажатие(ЭтотОбъект, Элемент);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ПредставлениеКИПриИзменении(Элемент)
	
	КонтактнаяИнформацияУНФКлиент.ПредставлениеКИПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ПредставлениеКИНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	КонтактнаяИнформацияУНФКлиент.ПредставлениеКИНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ПредставлениеКИОчистка(Элемент, СтандартнаяОбработка)
	
	КонтактнаяИнформацияУНФКлиент.ПредставлениеКИОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_КомментарийКИПриИзменении(Элемент)
	
	КонтактнаяИнформацияУНФКлиент.КомментарийКИПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияУНФВыполнитьКоманду(Команда)
	
	КонтактнаяИнформацияУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.КонтактнаяИнформация
// @skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
		УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) Экспорт
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	КонтактнаяИнформацияУНФКлиент.АвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	КонтактнаяИнформацияУНФКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

// СтандартныеПодсистемы.ПодключаемыеКоманды
// @skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
// @skip-warning
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры // Подключаемый_РедактироватьСоставСвойств()

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры // ОбновитьЭлементыДополнительныхРеквизитов()

// @skip-warning
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
&НаКлиенте
Процедура Склонения(Команда)
	
	СклонениеПредставленийОбъектовКлиент.ПоказатьСклонение(
		ЭтотОбъект, Объект.Наименование, ПараметрыСклоненияФИО(Объект));
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

#КонецОбласти
