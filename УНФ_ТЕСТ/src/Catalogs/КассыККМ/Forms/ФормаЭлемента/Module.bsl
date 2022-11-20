
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция формирует наименование банковского счета.
//
&НаКлиенте
Функция СформироватьАвтоНаименование()
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	СтрокаНаименования = "" + Объект.ТипКассы + " (" + Объект.СтруктурнаяЕдиница + ")";
	
	Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	
	Возврат СтрокаНаименования;

КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВалютаДенежныхСредств) Тогда
		Объект.ВалютаДенежныхСредств = Константы.НациональнаяВалюта.Получить();
	КонецЕсли;
	
	ИспользоватьПодключаемоеОборудование = Константы.ФункциональнаяОпцияИспользоватьПодключаемоеОборудование.Получить();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
	   И НЕ Параметры.ЗначенияЗаполнения.Свойство("Владелец")
	   И НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
			Объект.Владелец = ЗначениеНастройки;
		Иначе
			Объект.Владелец = Справочники.Организации.ОрганизацияПоУмолчанию();
		КонецЕсли;
		Если НЕ ИспользоватьПодключаемоеОборудование Тогда
			Объект.ИспользоватьБезПодключенияОборудования = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ТипКассыПриИзмененииНаСервере();
	
	Если Объект.ИспользоватьБезПодключенияОборудования
	И НЕ Константы.ФункциональнаяОпцияИспользоватьПодключаемоеОборудование.Получить() Тогда
		Элементы.ИспользоватьБезПодключенияОборудования.Доступность = Ложь;
	КонецЕсли;
	
	Элементы.ПодключаемоеОборудование.Доступность = НЕ Объект.ИспользоватьБезПодключенияОборудования;
	Элементы.ИсточникФИОКассираВЧеке.Доступность = НЕ Объект.ИспользоватьБезПодключенияОборудования;
	
	ИспользоватьОбменСПодключаемымОборудованием = ПолучитьФункциональнуюОпцию("ИспользоватьОбменСПодключаемымОборудованиемOffline");
	
	Если ИспользоватьОбменСПодключаемымОборудованием Тогда
		Элементы.ТипКассы.СписокВыбора.Добавить(Перечисления.ТипыКассККМ.ККМOffline);
		Элементы.ТипКассы.СписокВыбора.Добавить(Перечисления.ТипыКассККМ.СервисОборудования);
	КонецЕсли;
	
	Элементы.Владелец.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	УстановитьВидимостьДопСвойств();
	
	Элементы.РеквизитыККТ.ТолькоПросмотр = ЭтаФорма.ТолькоПросмотр;
	
	ФОУчетПоНесколькимСкладам = ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам");
	Элементы.ГруппаОткрытьКарточкуСклада.Видимость = НЕ ФОУчетПоНесколькимСкладам;
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Переход с предыдущих версий
	Если Объект.ИсточникФИОКассираВЧеке.Пустая() Тогда
		Объект.ИсточникФИОКассираВЧеке = Перечисления.ИсточникиФИОКассираВЧекеККМ.Автор;
	КонецЕсли;
	// Конец Переход с предыдущих версий
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура СброситьОборудованиеИПризнакиККТ()
	
	Объект.ПодключаемоеОборудование = Неопределено;
	Объект.ЭлектронныйЧекSMSПередаютсяПрограммой1С = Ложь;
	Объект.ЭлектронныйЧекEmailПередаютсяПрограммой1С = Ложь;
	Email = "ЧерезОФД";
	SMS = "ЧерезОФД";
	
КонецПроцедуры

&НаСервере
Процедура ТипКассыПриИзмененииНаСервере()
	
	Если Объект.ТипКассы = Перечисления.ТипыКассККМ.ФискальныйРегистратор Тогда
		
		Элементы.ИспользоватьБезПодключенияОборудования.Видимость = Истина;
		Элементы.ПодключаемоеОборудование.Видимость = Истина;
		Элементы.ИсточникФИОКассираВЧеке.Видимость = Истина;
		
		ПараметрыВыбораПодключаемогоОборудования = Новый Массив;
		
		Значения = Новый Массив;
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ФискальныйРегистратор"));
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ПринтерЧеков"));
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККТ"));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.ТипОборудования", Значения));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.УстройствоИспользуется", Истина));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
		
		Элементы.ПодключаемоеОборудование.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораПодключаемогоОборудования);
		
		Если Объект.ПодключаемоеОборудование.ТипОборудования <> Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор
			И Объект.ПодключаемоеОборудование.ТипОборудования <> Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков
			И Объект.ПодключаемоеОборудование.ТипОборудования <> Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
			СброситьОборудованиеИПризнакиККТ();
		КонецЕсли;
		
	ИначеЕсли Объект.ТипКассы = Перечисления.ТипыКассККМ.ККМOffline Тогда
		
		Элементы.ИспользоватьБезПодключенияОборудования.Видимость = Ложь;
		Элементы.ПодключаемоеОборудование.Видимость = Истина;
		Элементы.ИсточникФИОКассираВЧеке.Видимость = Ложь;
		
		ПараметрыВыбораПодключаемогоОборудования = Новый Массив;
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.ТипОборудования", Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.УстройствоИспользуется", Истина));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
		
		Элементы.ПодключаемоеОборудование.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораПодключаемогоОборудования);
		
		Если Объект.ПодключаемоеОборудование.ТипОборудования <> Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн Тогда
			СброситьОборудованиеИПризнакиККТ();
		КонецЕсли;
		
	ИначеЕсли Объект.ТипКассы = Перечисления.ТипыКассККМ.СервисОборудования Тогда
		
		Элементы.ИспользоватьБезПодключенияОборудования.Видимость = Ложь;
		Элементы.ПодключаемоеОборудование.Видимость = Истина;
		Элементы.ИсточникФИОКассираВЧеке.Видимость = Ложь;
		
		ПараметрыВыбораПодключаемогоОборудования = Новый Массив;
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.ТипОборудования", Перечисления.ТипыПодключаемогоОборудования.УдалитьWebСервисОборудование));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.УстройствоИспользуется", Истина));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
		
		Элементы.ПодключаемоеОборудование.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораПодключаемогоОборудования);
		
		Если Объект.ПодключаемоеОборудование.ТипОборудования <> Перечисления.ТипыПодключаемогоОборудования.УдалитьWebСервисОборудование Тогда
			СброситьОборудованиеИПризнакиККТ();
		КонецЕсли;
		
	Иначе
		
		Элементы.ИспользоватьБезПодключенияОборудования.Видимость = Ложь;
		Элементы.ПодключаемоеОборудование.Видимость = Ложь;
		Элементы.ИсточникФИОКассираВЧеке.Видимость = Ложь;
		
	КонецЕсли;
	
	УстановитьВидимостьДопСвойств();
	
КонецПроцедуры // ТипКассыПриИзмененииНаСервере()

&НаКлиенте
Процедура ТипКассыПриИзменении(Элемент)
	
	ТипКассыПриИзмененииНаСервере();
	СформироватьАвтоНаименование();
	НастроитьВидимостьЭлементовАвтоинкассации();
	
КонецПроцедуры // ТипКассыПриИзменении()

&НаКлиенте
Процедура ПодключаемоеОборудованиеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаОбъекта", Новый Структура("Ключ", Объект.ПодключаемоеОборудование));
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьБезПодключенияОборудованияПриИзменении(Элемент)
	
	Элементы.ПодключаемоеОборудование.Доступность = НЕ Объект.ИспользоватьБезПодключенияОборудования;
	Элементы.ИсточникФИОКассираВЧеке.Доступность = НЕ Объект.ИспользоватьБезПодключенияОборудования;
	УстановитьВидимостьДопСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьАвтоНаименование();
	ЗаполнитьEmail();
	ЗаполнитьSMS();
	НастроитьВидимостьЭлементовАвтоинкассации();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура СтруктурнаяЕдиницаПриИзменении(Элемент)
	
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменилисьСчетаКассыККМ" Тогда
		Объект.СчетУчета = Параметр.СчетУчета;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСклады(Команда)
	
	ПараметрыФормы = Новый Структура("Ключ", ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы.ОсновнойСклад"));
	ОткрытьФорму("Справочник.СтруктурныеЕдиницы.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьВидимостьЭлементовАвтоинкассации()
	
	ЭтоФискальныйРегистратор = (Объект.ТипКассы = ПредопределенноеЗначение("Перечисление.ТипыКассККМ.ФискальныйРегистратор"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаАвтоинкассация", "Видимость", ЭтоФискальныйРегистратор);
	
	Если Не ЭтоФискальныйРегистратор Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "МинимальныйОстатокВКассеККМ", "Доступность", Объект.СоздаватьВыемку);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПВК", "Доступность", Объект.СоздаватьВыемку);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КассаДляРозничнойВыручки", "Доступность", Объект.СоздаватьПоступлениеВКассу);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КассаДляРозничнойВыручки", "ОтметкаНезаполненного", Объект.СоздаватьПоступлениеВКассу);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьВыемкуПриИзменении(Элемент)
	
	НастроитьВидимостьЭлементовАвтоинкассации();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьПоступлениеВКассуПриИзменении(Элемент)
	
	НастроитьВидимостьЭлементовАвтоинкассации();
	Если Объект.СоздаватьПоступлениеВКассу И Объект.КассаДляРозничнойВыручки.Пустая() Тогда
		Объект.КассаДляРозничнойВыручки = ЗаполнитьКассуДляВыручкиПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗаполнитьКассуДляВыручкиПоУмолчанию()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	Кассы.Ссылка КАК Касса
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|ГДЕ
	|	НЕ Кассы.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		Возврат Выборка.Касса;
	Иначе
		Возврат Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Оповещение = Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение",ЭтаФорма);
		ОткрытьФорму("Справочник.КассыККМ.Форма.РазрешитьРедактирование",,,,,,Оповещение);
	КонецЕсли;
	
КонецПроцедуры // Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта()

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат,Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура ПодключаемоеОборудованиеПриИзмененииНаСервере()
	
	Объект.СерийныйНомер = Объект.ПодключаемоеОборудование.СерийныйНомер;
	Объект.ТипОборудования = Объект.ПодключаемоеОборудование.ТипОборудования;
	
	УстановитьВидимостьДопСвойств();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДопСвойств()
	
	Если Объект.ТипКассы = Перечисления.ТипыКассККМ.ФискальныйРегистратор Тогда
		Если Объект.ПодключаемоеОборудование.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
			Элементы.РеквизитыККТ.Видимость = Истина;
		Иначе
			Элементы.РеквизитыККТ.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.РеквизитыККТ.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.ИспользоватьБезПодключенияОборудования Тогда
		Элементы.РеквизитыККТ.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ТипКассы)
		Или Объект.ТипКассы = Перечисления.ТипыКассККМ.АвтономнаяККМ
		Или Объект.ТипКассы = Перечисления.ТипыКассККМ.ККМOffline
		Или Объект.ТипКассы = Перечисления.ТипыКассККМ.СервисОборудования Тогда
			Элементы.ИспользоватьАвторизациюПоОтветственному.Видимость = Ложь;
		Иначе
			Элементы.ИспользоватьАвторизациюПоОтветственному.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключаемоеОборудованиеПриИзменении(Элемент)
	ПодключаемоеОборудованиеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура EmailПриИзменении(Элемент)
	
	Объект.ЭлектронныйЧекEmailПередаютсяПрограммой1С = Email = "ИзПриложения";
	
КонецПроцедуры

&НаКлиенте
Процедура SMSПриИзменении(Элемент)
	
	Объект.ЭлектронныйЧекSMSПередаютсяПрограммой1С = SMS = "ИзПриложения";
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьEmail()
	
	Если Объект.ЭлектронныйЧекEmailПередаютсяПрограммой1С Тогда
		Email = "ИзПриложения";
	Иначе
		Email = "ЧерезОФД";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьSMS()
	
	Если Объект.ЭлектронныйЧекSMSПередаютсяПрограммой1С Тогда
		SMS = "ИзПриложения";
	Иначе
		SMS = "ЧерезОФД";
	КонецЕсли
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	НужноОбновитьЗначения = Ложь;
	ПараметрыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(Объект.Ссылка);
	Если Объект.СоздаватьВыемку <> ПараметрыККМ.СоздаватьВыемку Тогда
		НужноОбновитьЗначения = Истина;
	КонецЕсли;
	Если Объект.СоздаватьПоступлениеВКассу <> ПараметрыККМ.СоздаватьПоступлениеВКассу Тогда
		НужноОбновитьЗначения = Истина;
	КонецЕсли;
	Если Объект.МинимальныйОстатокВКассеККМ <> ПараметрыККМ.МинимальныйОстатокВКассеККМ Тогда
		НужноОбновитьЗначения = Истина;
	КонецЕсли;
	Если Объект.КассаДляРозничнойВыручки <> ПараметрыККМ.КассаДляРозничнойВыручки Тогда
		НужноОбновитьЗначения = Истина;
	КонецЕсли;
	
	Если НужноОбновитьЗначения Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
