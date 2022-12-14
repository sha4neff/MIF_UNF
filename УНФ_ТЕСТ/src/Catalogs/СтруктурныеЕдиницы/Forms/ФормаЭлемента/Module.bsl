
#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭлементОсновной()
	
	Если Объект.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Подразделение Тогда
		Настройка = ПланыВидовХарактеристик.НастройкиПользователей["ОсновноеПодразделение"]
	Иначе
		Настройка = ПланыВидовХарактеристик.НастройкиПользователей["ОсновнойСклад"]
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователи.АвторизованныйПользователь());
	Запрос.УстановитьПараметр("Настройка", Настройка);
	Запрос.УстановитьПараметр("Значение", Объект.Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиПользователей.Пользователь КАК Пользователь,
	|	НастройкиПользователей.Настройка КАК Настройка,
	|	НастройкиПользователей.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.НастройкиПользователей КАК НастройкиПользователей
	|ГДЕ
	|	НастройкиПользователей.Пользователь = &Пользователь
	|	И НастройкиПользователей.Настройка = &Настройка
	|	И НастройкиПользователей.Значение = &Значение";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеПодписи(ПодписьМОЛ)
	
	СтруктураДанных	 = Новый Структура;
	
	СтруктураДанных.Вставить("ФизическоеЛицо",
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПодписьМОЛ, "ФизическоеЛицо"));
	
	Возврат СтруктураДанных;
	
КонецФункции

// Возвращает структуру данных по полученному виду цен
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеРозничногоВидаЦен(РозничныйВидЦен)
	
	СтруктураДанных	 = Новый Структура;
	
	СтруктураДанных.Вставить("НаименованиеВидаЦен",	РозничныйВидЦен.Наименование);
	СтруктураДанных.Вставить("НациональнаяВалюта",	Константы.НациональнаяВалюта.Получить());
	СтруктураДанных.Вставить("ВалютаЦены", 			РозничныйВидЦен.ВалютаЦены);
	
	Возврат СтруктураДанных;
	
КонецФункции //ПолучитьДанныеРозничногоВидаЦен()

&НаСервере
Процедура ОтметитьОшибки(ПереченьОшибок)
	
	ЦветПодсветки = ЦветТекстаНекорректногоЗаполнения;
	
	Если ПереченьОшибок.Получить("ПредставлениеКИ_1")<> Неопределено Тогда
		НайденныеСтроки = ЭтаФорма.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы));
		Если НайденныеСтроки.Количество() > 0 Тогда
			Попытка
				Элементы.ВидКИ_1.ЦветТекста = ЦветПодсветки;
			Исключение
			КонецПопытки;
		КонецЕсли;
		СтрокаОписанияОшибки = ОшибкиЗаполнения.Добавить();
		СтрокаОписанияОшибки.ИмяПоля =   "ВидКИ_1";
		СтрокаОписанияОшибки.ИмяГруппы = "КонтактнаяИнформация";
		Элементы.КонтактнаяИнформация.ЦветТекстаЗаголовка = ЦветПодсветки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеЭлемента(ИмяЭлемента)
	Если РежимИсправленияОшибок Тогда
		ПроверитьЗаполнениеЭлементаНаСервере(ИмяЭлемента);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеЭлементаНаСервере(ИмяЭлемента)
	
	СтрокиОшибкиЗаполнения = ОшибкиЗаполнения.НайтиСтроки(Новый Структура("ИмяПоля",ИмяЭлемента));
	Если СтрокиОшибкиЗаполнения.Количество() > 0 Тогда
		Строка = СтрокиОшибкиЗаполнения[0];
		ПроверкаВыполненаУспешно = Ложь;
		Если ИмяЭлемента = "ВидКИ_1" Тогда
			Строки = ЭтаФорма.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы));
			Если Строки.Количество() > 0 И НЕ ПустаяСтрока(Строки[0].Представление) Тогда
				ПроверкаВыполненаУспешно = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ПроверкаВыполненаУспешно Тогда
			Если СтрНайти(ИмяЭлемента, "ВидКИ") > 0 Тогда
				Элементы[ИмяЭлемента].ЦветТекста = ЦветТекста;
			Иначе
				Элементы[ИмяЭлемента].ЦветТекстаЗаголовка = ЦветТекста;
			КонецЕсли;
			Строка.ЗаполненоКорректно = Истина;
			Если Не ПустаяСтрока(Строка.ИмяГруппы) Тогда
				СтрокиГруппы = ОшибкиЗаполнения.НайтиСтроки(Новый Структура("ИмяГруппы, ЗаполненоКорректно",Строка.ИмяГруппы, Ложь));
				Если СтрокиГруппы.Количество() = 0 Тогда
					Элементы[Строка.ИмяГруппы].ЦветТекстаЗаголовка = Новый Цвет;
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если СтрНайти(ИмяЭлемента, "ВидКИ") > 0 Тогда
				Элементы[ИмяЭлемента].ЦветТекста = ЦветТекстаНекорректногоЗаполнения;
			Иначе
				Элементы[ИмяЭлемента].ЦветТекстаЗаголовка = ЦветТекстаНекорректногоЗаполнения;
			КонецЕсли;
			Строка.ЗаполненоКорректно = Ложь;
			Если Не ПустаяСтрока(Строка.ИмяГруппы) Тогда
				Элементы[Строка.ИмяГруппы].ЦветТекстаЗаголовка = ЦветТекстаНекорректногоЗаполнения;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоперемещениеЗапасовНажатиеЗавершение(ПараметрыЗаполнения,Параметры) Экспорт
	
	Если ТипЗнч(ПараметрыЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(Объект, ПараметрыЗаполнения);
		
		Если НЕ Модифицированность 
			И ПараметрыЗаполнения.Модифицированность Тогда
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Процедура ГоловныеОрганизацииОбособленногоПодразделения()
	
	СписокВыбораОрганизаций = Элементы.ГоловнаяОрганизация.СписокВыбора;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяСсылка", Объект.Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка, Организации.Наименование КАК Наименование
	|ИЗ Справочник.Организации КАК Организации
	|ГДЕ Организации.ЮридическоеФизическоеЛицо = Значение(Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо)
	|	И Организации.ГоловнаяОрганизация = Значение(Справочник.Организации.ПустаяСсылка)
	|	И Организации.Ссылка <> &ТекущаяСсылка
	|УПОРЯДОЧИТЬ ПО Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СписокВыбораОрганизаций.Добавить(Выборка.Ссылка, Выборка.Наименование);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВСправочникеОтсутствуетСтруктурнаяЕдиницаСТипомСклад()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтруктурныеЕдиницы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|ГДЕ
	|	СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Склад)");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции

#Область КонтактнаяИнформацияУНФ

&НаСервере
Процедура ДобавитьКонтактнуюИнформациюСервер(ДобавляемыйВид, УстановитьВыводВФормеВсегда = Ложь) Экспорт
	
	КонтактнаяИнформацияУНФ.ДобавитьКонтактнуюИнформацию(ЭтотОбъект, ДобавляемыйВид, УстановитьВыводВФормеВсегда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДействиеКИНажатие(Элемент)
	
	КонтактнаяИнформацияУНФКлиент.ДействиеКИНажатие(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПредставлениеКИПриИзменении(Элемент)
	
	КонтактнаяИнформацияУНФКлиент.ПредставлениеКИПриИзменении(ЭтотОбъект, Элемент);
	ПроверитьЗаполнениеЭлемента("ВидКИ_" + Прав(Элемент.Имя, 1));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПредставлениеКИНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура("ИмяЭлемента", "ВидКИ_" + Прав(Элемент.Имя, 1));
	ОповещениеОЗакрытииДиалога = Новый ОписаниеОповещения("ДополнительныеДействияПриЗакрытииДиалога", ЭтотОбъект, ДополнительныеПараметры);
	КонтактнаяИнформацияУНФКлиент.ПредставлениеКИНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка, ОповещениеОЗакрытииДиалога);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПредставлениеКИОчистка(Элемент, СтандартнаяОбработка)
	
	КонтактнаяИнформацияУНФКлиент.ПредставлениеКИОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийКИПриИзменении(Элемент)
	
	КонтактнаяИнформацияУНФКлиент.КомментарийКИПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияУНФВыполнитьКоманду(Команда)
	
	КонтактнаяИнформацияУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеДействияПриЗакрытииДиалога(Результат, ДополнительныеПараметры) Экспорт
	
	ПроверитьЗаполнениеЭлемента(ДополнительныеПараметры.ИмяЭлемента);
	
КонецПроцедуры

// СтандартныеПодсистемы.КонтактнаяИнформация
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) Экспорт
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Если 1=0 Тогда
		УправлениеКонтактнойИнформациейКлиент.АвтоПодборАдреса(Текст, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если 1=0 Тогда
		УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
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
	ДополнительныеПараметры = УправлениеСвойствамиПереопределяемый.ЗаполнитьДополнительныеПараметры(Объект, "ГруппаРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	ТипСтруктурнойЕдиницыРозница = Перечисления.ТипыСтруктурныхЕдиниц.Розница;
	ТипСтруктурнойЕдиницыРозницаСуммовойУчет = Перечисления.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет;
	ТипСтруктурнойЕдиницыСклад = Перечисления.ТипыСтруктурныхЕдиниц.Склад;
	ТипСтруктурнойЕдиницыПодразделение = Перечисления.ТипыСтруктурныхЕдиниц.Подразделение;
	
	Элементы.ОрдерныйСклад.Доступность = Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыСклад;
	Элементы.РозничныйВидЦен.Видимость = НЕ (Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыПодразделение);
	Если РольДоступна("ЧтениеДанныхУНФ") Тогда
		Элементы.ОбработкаВидыСкидокНаценокРучныеИАвтоматическиеОткрытьОкругления.Видимость = НЕ (Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыПодразделение);
	КонецЕсли;
	
	УчетРозничныхПродаж = ПолучитьФункциональнуюОпцию("УчетРозничныхПродаж");
	Элементы.ОбработкаМенеджерПодсказокТиповыеСхемыУчета_Розница.Видимость = Элементы.РозничныйВидЦен.Видимость И УчетРозничныхПродаж;
	Элементы.ТипСтруктурнойЕдиницы.ОтображениеПодсказки = ?(Элементы.РозничныйВидЦен.Видимость И УчетРозничныхПродаж, ОтображениеПодсказки.Кнопка, ОтображениеПодсказки.Нет);
	
	Если ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам")
		Или Объект.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Склад
		Или ВСправочникеОтсутствуетСтруктурнаяЕдиницаСТипомСклад() Тогда
		Элементы.ТипСтруктурнойЕдиницы.СписокВыбора.Добавить(Перечисления.ТипыСтруктурныхЕдиниц.Склад);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("УчетРозничныхПродаж")
		ИЛИ Объект.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Розница
		ИЛИ Объект.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет Тогда
		Элементы.ТипСтруктурнойЕдиницы.СписокВыбора.Добавить(Перечисления.ТипыСтруктурныхЕдиниц.Розница);
		Элементы.ТипСтруктурнойЕдиницы.СписокВыбора.Добавить(Перечисления.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет);
	КонецЕсли;
	
	Если Константы.ФункциональнаяОпцияУчетПоНесколькимПодразделениям.Получить()
		ИЛИ Объект.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Подразделение Тогда
		Элементы.ТипСтруктурнойЕдиницы.СписокВыбора.Добавить(Перечисления.ТипыСтруктурныхЕдиниц.Подразделение);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
		  И Элементы.ТипСтруктурнойЕдиницы.СписокВыбора.Количество() = 1 Тогда
		Объект.ТипСтруктурнойЕдиницы = Элементы.ТипСтруктурнойЕдиницы.СписокВыбора[0].Значение;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных") Тогда
		Элементы.Организация.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.РозничныйВидЦен.Доступность = НЕ Объект.ОрдерныйСклад;
	Элементы.РозничныйВидЦен.АвтоОтметкаНезаполненного = (
		Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыРозница
		ИЛИ Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыРозницаСуммовойУчет
	);
	
	ГоловныеОрганизацииОбособленногоПодразделения();
	
	ЭтоПодразделение = (Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыПодразделение);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГоловнаяОрганизация", "Видимость", ЭтоПодразделение);
	
	РеквизитыГоловнойОрганизацииВидны = ЭтоПодразделение И ЗначениеЗаполнено(Объект.ГоловнаяОрганизация);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГоловнаяОрганизацияИНН",					"Видимость", РеквизитыГоловнойОрганизацииВидны);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КПП", 										"Видимость", РеквизитыГоловнойОрганизацииВидны);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЦифровойИндексОбособленногоПодразделения",	"Видимость", РеквизитыГоловнойОрганизацииВидны);
	
	ИспользуетсяПриемНаОтветХранение = ПолучитьФункциональнуюОпцию("ПриемЗапасовНаОтветхранение");
	Если ИспользуетсяПриемНаОтветХранение Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УсловияХранения", "Видимость", (Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыСклад));
		
	КонецЕсли;
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветТекстаНекорректногоЗаполнения = ЦветаСтиля.ЦветТекстаНекорректногоКонтрагента;
	РежимИсправленияОшибок = Параметры.ОшибкиЗаполнения;
	Если РежимИсправленияОшибок Тогда
		ПроверкаДанных.ВывестиСообщенияОбОшибкахЗаполнения("Объект", Параметры.ПереченьОшибок);
		ОтметитьОшибки(Параметры.ПереченьОшибок);
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

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
	
КонецПроцедуры // ПриЧтенииНаСервере()

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
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменилисьСчетаСтруктурныеЕдиницы" Тогда
		Объект.СчетУчетаВРознице = Параметр.СчетУчетаВРознице;
		Объект.СчетУчетаНаценки = Параметр.СчетУчетаНаценки;
		Модифицированность = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры // ОбработкаОповещения()

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект); // для проверки внедрения БСП
	КонтактнаяИнформацияУНФ.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ПараметрыЗаписи.Вставить("ЭтоНовый", ТекущийОбъект.ЭтоНовый());
	
КонецПроцедуры // ПередЗаписьюНаСервере()

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
	
КонецПроцедуры // ОбработкаПроверкиЗаполненияНаСервере()

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	Если ПараметрыЗаписи.Свойство("ЭтоНовый") И ПараметрыЗаписи.ЭтоНовый Тогда
		УправлениеНебольшойФирмойСервер.ПроверитьУстановитьФОУчетПоНесколькимСкладамПодразделениям(Объект.ТипСтруктурнойЕдиницы);
	КонецЕсли;
	
КонецПроцедуры // ПослеЗаписиНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьДополнительныйРеквизит(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийНаборСвойств", ПредопределенноеЗначение("Справочник.НаборыДополнительныхРеквизитовИСведений.Справочник_СтруктурныеЕдиницы"));
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Ложь);
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура МОЛПриИзменении(Элемент)
	
	Объект.ПодписьМОЛ = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьМОЛПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ПодписьМОЛ) Тогда
		
		Объект.МОЛ = Неопределено;
		Возврат;
		
	КонецЕсли;
	
	ДеталиПодписи = ПолучитьДанныеПодписи(Объект.ПодписьМОЛ);
	Объект.МОЛ = ДеталиПодписи.ФизическоеЛицо;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСтруктурнойЕдиницыПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ТипСтруктурнойЕдиницы) Тогда
		
		Если Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыСклад Тогда
			
			Элементы.ОрдерныйСклад.Доступность = Истина;
		Иначе
			
			Элементы.ОрдерныйСклад.Доступность = Ложь;
			Объект.ОрдерныйСклад = Ложь;
			
		КонецЕсли;
		
		Если ИспользуетсяПриемНаОтветХранение Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УсловияХранения", "Видимость", (Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыСклад));
			
		КонецЕсли;
		
		Элементы.РозничныйВидЦен.Видимость = (
			Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыРозница
			ИЛИ Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыСклад
			ИЛИ Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыРозницаСуммовойУчет
		);
		
		Элементы.ОбработкаМенеджерПодсказокТиповыеСхемыУчета_Розница.Видимость = Элементы.РозничныйВидЦен.Видимость И УчетРозничныхПродаж;
		Элементы.ТипСтруктурнойЕдиницы.ОтображениеПодсказки = ?(Элементы.РозничныйВидЦен.Видимость И УчетРозничныхПродаж, ОтображениеПодсказки.Кнопка, ОтображениеПодсказки.Нет);
		
		Элементы.РозничныйВидЦен.ОтметкаНезаполненного = (
			Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыРозница
			ИЛИ Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыРозницаСуммовойУчет
		);
		
	Иначе
		
		Элементы.ОрдерныйСклад.Доступность = Ложь;
		Объект.ОрдерныйСклад = Ложь;
		
	КонецЕсли;
	
	Элементы.ОбработкаВидыСкидокНаценокРучныеИАвтоматическиеОткрытьОкругления.Видимость = НЕ (Объект.ТипСтруктурнойЕдиницы = ТипСтруктурнойЕдиницыПодразделение);
	
	ЭтоПодразделение = (Объект.ТипСтруктурнойЕдиницы = ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.Подразделение"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГоловнаяОрганизация",						"Видимость", ЭтоПодразделение);
	
	РеквизитыГоловнойОрганизацииВидны = ЭтоПодразделение И ЗначениеЗаполнено(Объект.ГоловнаяОрганизация);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГоловнаяОрганизацияИНН",					"Видимость", РеквизитыГоловнойОрганизацииВидны);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КПП", 										"Видимость", РеквизитыГоловнойОрганизацииВидны);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЦифровойИндексОбособленногоПодразделения",	"Видимость", РеквизитыГоловнойОрганизацииВидны);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоперемещениеЗапасовНажатие(Элемент)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИсточникПеремещения", Объект.ИсточникПеремещения);
	СтруктураПараметров.Вставить("ПолучательПеремещения", Объект.ПолучательПеремещения);
	СтруктураПараметров.Вставить("ПолучательОтходов", Объект.ПолучательОтходов);
	СтруктураПараметров.Вставить("ИсточникСписанияНаРасходы", Объект.ИсточникСписанияНаРасходы);
	СтруктураПараметров.Вставить("ПолучательСписанияНаРасходы", Объект.ПолучательСписанияНаРасходы);
	СтруктураПараметров.Вставить("ИсточникПередачиВЭксплуатацию", Объект.ИсточникПередачиВЭксплуатацию);
	СтруктураПараметров.Вставить("ПолучательПередачиВЭксплуатацию", Объект.ПолучательПередачиВЭксплуатацию);
	СтруктураПараметров.Вставить("ИсточникВозвратаИзЭксплуатации", Объект.ИсточникВозвратаИзЭксплуатации);
	СтруктураПараметров.Вставить("ПолучательВозвратаИзЭксплуатации", Объект.ПолучательВозвратаИзЭксплуатации);
	
	СтруктураПараметров.Вставить("ЯчейкаИсточникаПеремещения", Объект.ЯчейкаИсточникаПеремещения);
	СтруктураПараметров.Вставить("ЯчейкаПолучателяПеремещения", Объект.ЯчейкаПолучателяПеремещения);
	СтруктураПараметров.Вставить("ЯчейкаПолучателяОтходов", Объект.ЯчейкаПолучателяОтходов);
	СтруктураПараметров.Вставить("ЯчейкаИсточникаСписанияНаРасходы", Объект.ЯчейкаИсточникаСписанияНаРасходы);
	СтруктураПараметров.Вставить("ЯчейкаПолучателяСписанияНаРасходы", Объект.ЯчейкаПолучателяСписанияНаРасходы);
	СтруктураПараметров.Вставить("ЯчейкаИсточникаПередачиВЭксплуатацию", Объект.ЯчейкаИсточникаПередачиВЭксплуатацию);
	СтруктураПараметров.Вставить("ЯчейкаПолучателяПередачиВЭксплуатацию", Объект.ЯчейкаПолучателяПередачиВЭксплуатацию);
	СтруктураПараметров.Вставить("ЯчейкаИсточникаВозвратаИзЭксплуатации", Объект.ЯчейкаИсточникаВозвратаИзЭксплуатации);
	СтруктураПараметров.Вставить("ЯчейкаПолучателяВозвратаИзЭксплуатации", Объект.ЯчейкаПолучателяВозвратаИзЭксплуатации);
	
	СтруктураПараметров.Вставить("ТипСтруктурнойЕдиницы", Объект.ТипСтруктурнойЕдиницы);
	
	Оповещение = Новый ОписаниеОповещения("АвтоперемещениеЗапасовНажатиеЗавершение",ЭтотОбъект);
	ОткрытьФорму("Справочник.СтруктурныеЕдиницы.Форма.ФормаАвтоперемещенияЗапасов", СтруктураПараметров,,,,,Оповещение);
	
КонецПроцедуры // АвтоперемещениеЗапасовНажатие()

&НаКлиенте
Процедура РозничныйВидЦенПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.РозничныйВидЦен) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = ПолучитьДанныеРозничногоВидаЦен(Объект.РозничныйВидЦен);
	
	Если НЕ СтруктураДанных.ВалютаЦены = СтруктураДанных.НациональнаяВалюта Тогда
		
		ТекстСообщения = НСтр("ru = 'У вида цен ""%ВидЦен%"", для розничной структурной единицы, должна быть задана национальная валюта (%НацВалюта%).'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВидЦен%", СтруктураДанных.НаименованиеВидаЦен);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НацВалюта%", СтруктураДанных.НациональнаяВалюта);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.РозничныйВидЦен");
		
		Объект.РозничныйВидЦен = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры //РозничныйВидЦенПриИзменении()

&НаКлиенте
Процедура ОрдерныйСкладПриИзменении(Элемент)
	
	Элементы.РозничныйВидЦен.Доступность = НЕ Объект.ОрдерныйСклад;
	
КонецПроцедуры

&НаКлиенте
Процедура ГоловнаяОрганизацияПриИзменении(Элемент)
	
	ЭтоПодразделение = (Объект.ТипСтруктурнойЕдиницы = ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.Подразделение"));
	
	РеквизитыГоловнойОрганизацииВидны = ЭтоПодразделение И ЗначениеЗаполнено(Объект.ГоловнаяОрганизация);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГоловнаяОрганизацияИНН",					"Видимость", РеквизитыГоловнойОрганизацииВидны);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КПП", 										"Видимость", РеквизитыГоловнойОрганизацииВидны);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЦифровойИндексОбособленногоПодразделения",	"Видимость", РеквизитыГоловнойОрганизацииВидны);
	
КонецПроцедуры

&НаКлиенте
Процедура НедействителенПриИзменении(Элемент)
	
	Если Не Объект.Недействителен Тогда Возврат КонецЕсли;
	
	Если ЭлементОсновной() Тогда
		ПараметрыОповещения = Новый Структура();
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеЗакрытияПредупрежденияНедействителен", ЭтотОбъект, ПараметрыОповещения);
		ПоказатьПредупреждение(ОповещениеОЗакрытии, НСтр("ru = 'Для установки ""Недействителен"" необходимо выбрать основным дургой элемент справочника.'"), , НСтр("ru = 'Элемент выбран основным'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияПредупрежденияНедействителен(Параметры) Экспорт
	Объект.Недействителен = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры // Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта()
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

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры // Подключаемый_РедактироватьСоставСвойств()

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры // ОбновитьЭлементыДополнительныхРеквизитов()

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	ОбработкаЗаписиНовогоНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбработкаЗаписиНовогоНаСервере()
	// Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если Объект.ТипСтруктурнойЕдиницы=ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.Склад") Тогда
		Оповестить("Запись_Склад", Объект.Ссылка);
	КонецЕсли; 
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти


