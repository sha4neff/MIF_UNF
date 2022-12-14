
#Область ПрограммныйИнтерфейс

#Область СобытияЭлементовФормы

Процедура ДействиеКИНажатие(Форма, Элемент) Экспорт
	
	ИндексКИ = Число(Сред(Элемент.Имя, СтрДлина("ДействиеКИ_")+1));
	
	ДанныеКИ = Новый Структура;
	ДанныеКИ.Вставить("Тип", Форма.КонтактнаяИнформация[ИндексКИ].Тип);
	ДанныеКИ.Вставить("Представление", Форма.КонтактнаяИнформация[ИндексКИ].Представление);
	ДанныеКИ.Вставить("Владелец", Форма.Объект.Ссылка);
	
	ОбработатьНажатиеПиктограммы(Форма, Элемент, ДанныеКИ);
	
КонецПроцедуры

Процедура ПредставлениеКИПриИзменении(Форма, Элемент) Экспорт
	
	ИндексКИ = Число(Сред(Элемент.Имя, СтрДлина("ПредставлениеКИ_")+1));
	ДанныеКИ = Форма.КонтактнаяИнформация[ИндексКИ];
	
	Если ПустаяСтрока(ДанныеКИ.Представление) Тогда
		ДанныеКИ.Значение = "";
	Иначе
		ДанныеКИ.Значение = КонтактнаяИнформацияУНФВызовСервера.КонтактнаяИнформацияПоПредставлению(ДанныеКИ.Представление, ДанныеКИ.Вид);
	КонецЕсли;
	
	Если ДанныеКИ.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		КонтактнаяИнформацияУНФКлиентСервер.ЗаполнитьСписокВыбораАдресов(Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредставлениеКИНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка, ОповещениеОЗакрытииДиалога = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ИндексКИ = Число(Сред(Элемент.Имя, СтрДлина("ПредставлениеКИ_")+1));
	ДанныеКИ = Форма.КонтактнаяИнформация[ИндексКИ];
	
	// Если представление было изменено в поле и не соответствует реквизиту, то приводим в соответствие.
	Если ДанныеКИ.Представление <> Элемент.ТекстРедактирования Тогда
		ДанныеКИ.Представление = Элемент.ТекстРедактирования;
		ПредставлениеКИПриИзменении(Форма, Элемент);
		Модифицированность = Истина;
	КонецЕсли;
	
	ПараметрыФормы = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
						ДанныеКИ.Вид,
						ДанныеКИ.Значение,
						ДанныеКИ.Представление,
						ДанныеКИ.Комментарий);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИндексКИ", ИндексКИ);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	Если ОповещениеОЗакрытииДиалога <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ОповещениеОЗакрытииДиалога", ОповещениеОЗакрытииДиалога);
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗначениеКИРедактированиеВДиалогеЗавершено", ЭтотОбъект, ДополнительныеПараметры);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, ЭтотОбъект, ОписаниеОповещения);
	
КонецПроцедуры

Процедура ПредставлениеКИОчистка(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	ИндексКИ = Число(Сред(Элемент.Имя, СтрДлина("ПредставлениеКИ_")+1));
	ДанныеКИ = Форма.КонтактнаяИнформация[ИндексКИ];
	ДанныеКИ.Значение = "";
	
	Если ДанныеКИ.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		КонтактнаяИнформацияУНФКлиентСервер.ЗаполнитьСписокВыбораАдресов(Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура КомментарийКИПриИзменении(Форма, Элемент) Экспорт
	
	ИндексКИ = Число(Сред(Элемент.Имя, СтрДлина("КомментарийКИ_")+1));
	ДанныеКИ = Форма.КонтактнаяИнформация[ИндексКИ];
	
	ОжидаемыйВид = ?(ПустаяСтрока(ДанныеКИ.Значение), ДанныеКИ.Вид, Неопределено);
	КонтактнаяИнформацияУНФВызовСервера.УстановитьКомментарийКонтактнойИнформации(ДанныеКИ.Значение, ДанныеКИ.Комментарий, ОжидаемыйВид);
	
КонецПроцедуры

Процедура АвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если СтрДлина(Текст) > 2 Тогда
		УправлениеКонтактнойИнформациейСлужебныйВызовСервера.АвтоподборАдреса(Текст, ДанныеВыбора);
		Если ТипЗнч(ДанныеВыбора) = Тип("СписокЗначений") Тогда
			СтандартнаяОбработка = (ДанныеВыбора.Количество() = 0);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаВыбора(Форма, ВыбранноеЗначение, Элемент, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ИндексКИ = Число(Сред(Элемент.Имя, СтрДлина("ПредставлениеКИ_")+1));
	ДанныеКИ = Форма.КонтактнаяИнформация[ИндексКИ];
	
	ДанныеКИ.Представление = ВыбранноеЗначение.Представление;
	ДанныеКИ.Значение = ВыбранноеЗначение.Адрес;
	
	Если ДанныеКИ.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		КонтактнаяИнформацияУНФКлиентСервер.ЗаполнитьСписокВыбораАдресов(Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКоманду(Форма, Команда) Экспорт
	
	Если Команда.Имя = "ДобавитьПолеКонтактнойИнформации"
		ИЛИ СтрНачинаетсяС(Команда.Имя, "ДобавитьПолеКонтактнойИнформации") И Форма.ЕстьКолонкаИдентификаторСтрокиТабличнойЧасти Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		Если Форма.ЕстьКолонкаИдентификаторСтрокиТабличнойЧасти Тогда
			ДополнительныеПараметры.Вставить("ИдентификаторСтрокиТабличнойЧасти", Число(СтрЗаменить(Команда.Имя, "ДобавитьПолеКонтактнойИнформации_", "")));
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьКонтактнуюИнформациюВидВыбран", ЭтотОбъект, ДополнительныеПараметры);
		
		СписокДоступныхВидов = КонтактнаяИнформацияУНФКлиентСервер.СписокВидовДляДобавленияКонтактнойИнформации(Форма);
		
		Форма.ПоказатьВыборИзМеню(ОписаниеОповещения, СписокДоступныхВидов, Форма.Элементы[Команда.Имя]);
		
	ИначеЕсли СтрНачинаетсяС(Команда.Имя, "КонтекстноеМенюКартаЯндекс_") Тогда
		
		ИндексКИ = Число(Сред(Команда.Имя, СтрДлина("КонтекстноеМенюКартаЯндекс_")+1));
		ДанныеКИ = Форма.КонтактнаяИнформация[ИндексКИ];
		УправлениеКонтактнойИнформациейКлиент.ПоказатьАдресНаКарте(ДанныеКИ.Представление, "Яндекс.Карты");
		
	ИначеЕсли СтрНачинаетсяС(Команда.Имя, "КонтекстноеМенюКартаGoogle_") Тогда
		
		ИндексКИ = Число(Сред(Команда.Имя, СтрДлина("КонтекстноеМенюКартаGoogle_")+1));
		ДанныеКИ = Форма.КонтактнаяИнформация[ИндексКИ];
		УправлениеКонтактнойИнформациейКлиент.ПоказатьАдресНаКарте(ДанныеКИ.Представление, "GoogleMaps");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Выполняет необходимое действие при нажатии на пиктограмму контактной информации.
//
// Параметры:
//  Форма    - ФормаКлиентскогоПриложения - Форма, из которой происходит вызов.
//  Элемент  - Элемент - Нажимаемая пиктограмма.
//  ДанныеКИ - Структура
//    * Представление - Строка
//    * Тип           - ПеречислениеСсылка.ТипКонтактнойИнформации
//    * Владелец      - Ссылка - Владелец контактной информации.
//  ОснованиеЗаполненияСобытия	 - Структура - Основание заполнения события. Используется для создания нового документа Событие,
//                                             если не определено специфическое действия для типа контактной информации.
//
Процедура ОбработатьНажатиеПиктограммы(Форма, Элемент, ДанныеКИ, ОснованиеЗаполненияСобытия = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДанныеКИ.Тип) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОснованиеЗаполненияСобытия = Неопределено Тогда
		ОснованиеЗаполненияСобытия = Новый Структура;
		ОснованиеЗаполненияСобытия.Вставить("Контакт", ДанныеКИ.Владелец);
	КонецЕсли;
	
	Если ДанныеКИ.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Тогда
		
		Если ТелефонияКлиент.ПоддерживаютсяВызовы() Тогда
			ТелефонияКлиент.ПозвонитьПоНомеру(ДанныеКИ.Представление, ДанныеКИ.Владелец);
		Иначе
			ЗначенияЗаполнения = Новый Структура;
			ЗначенияЗаполнения.Вставить("ТипСобытия", ТипСобытияПоТипуКонтактнойИнформации(ДанныеКИ.Тип));
			ЗначенияЗаполнения.Вставить("ОснованиеЗаполнения", ОснованиеЗаполненияСобытия);
			ОткрытьФорму("Документ.Событие.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), Форма);
		КонецЕсли;
		
	ИначеЕсли ДанныеКИ.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Skype") Тогда
		
		ЛогинSkype = ДанныеКИ.Представление;
		
		Если НЕ ЗначениеЗаполнено(ЛогинSkype) Тогда
			Возврат;
		КонецЕсли;
		
		ПредложитьЗапускSkype(Форма, Элемент, ЛогинSkype);
		
	ИначеЕсли ДанныеКИ.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница") Тогда
		
		ВебСсылка = ДанныеКИ.Представление;
		
		Если НЕ ЗначениеЗаполнено(ВебСсылка) Тогда
			Возврат;
		КонецЕсли;
		
		Если СтрНайти(ВебСсылка, "://") > 0 Тогда
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ВебСсылка);
		Иначе
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://" + ВебСсылка);
		КонецЕсли;
		
	Иначе
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ТипСобытия", ТипСобытияПоТипуКонтактнойИнформации(ДанныеКИ.Тип));
		ЗначенияЗаполнения.Вставить("ОснованиеЗаполнения", ОснованиеЗаполненияСобытия);
		
		ОткрытьФорму("Документ.Событие.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПозвонитьПоТелефону(ПредставлениеКИ, ВладелецКИ) Экспорт
	
	ОснованиеЗаполненияСобытия = Новый Структура;
	ОснованиеЗаполненияСобытия.Вставить("Контакт", ВладелецКИ);
	
	Если ТелефонияКлиент.ПоддерживаютсяВызовы() Тогда
		ТелефонияКлиент.ПозвонитьПоНомеру(ПредставлениеКИ, ВладелецКИ);
	Иначе
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ТипСобытия", ПредопределенноеЗначение("Перечисление.ТипыСобытий.ТелефонныйЗвонок"));
		ЗначенияЗаполнения.Вставить("ОснованиеЗаполнения", ОснованиеЗаполненияСобытия);
		ОткрытьФорму("Документ.Событие.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредложитьЗапускSkype(Форма, Элемент, ЛогинSkype) Экспорт
	
	ДополнительныеПараметры = Новый Структура("ЛогинSkype", ЛогинSkype);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПредложитьЗапускSkypeЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Список = Новый СписокЗначений;
	Список.Добавить("Позвонить", НСтр("ru = 'Позвонить'"));
	Список.Добавить("НачатьЧат", НСтр("ru = 'Начать чат'"));
	
	Форма.ПоказатьВыборИзМеню(ОписаниеОповещения, Список, Элемент);
	
КонецПроцедуры

Процедура ОткрытьSkype(СтрокаЗапуска) Экспорт
	
#Если НЕ ВебКлиент И НЕ МобильныйКлиент Тогда
	Если ПустаяСтрока(ПрограммаТелефонииУстановлена("skype")) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Для совершения звонка по Skype требуется установить программу.'"));
		Возврат;
	КонецЕсли;
#КонецЕсли
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗапускаПриложения", ЭтотОбъект);
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(СтрокаЗапуска, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает тип события по типу контактной информации
//
// Параметры:
//  ТипКИ	 - ПеречислениеСсылка.ТипыКонтактнойИнформации	 - тип контактной информации, для которого определяется тип события
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыСобытий - соответствующий тип события
//
Функция ТипСобытияПоТипуКонтактнойИнформации(ТипКИ) Экспорт
	
	Если ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Skype") Тогда
		ТипСобытия = ПредопределенноеЗначение("Перечисление.ТипыСобытий.Прочее");
	ИначеЕсли ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		ТипСобытия = ПредопределенноеЗначение("Перечисление.ТипыСобытий.ЛичнаяВстреча");
	ИначеЕсли ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
		ТипСобытия = ПредопределенноеЗначение("Перечисление.ТипыСобытий.ЭлектронноеПисьмо");
	ИначеЕсли ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница") Тогда
		ТипСобытия = ПредопределенноеЗначение("Перечисление.ТипыСобытий.Прочее");
	ИначеЕсли ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Другое") Тогда
		ТипСобытия = ПредопределенноеЗначение("Перечисление.ТипыСобытий.Прочее");
	ИначеЕсли ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Тогда
		ТипСобытия = ПредопределенноеЗначение("Перечисление.ТипыСобытий.ТелефонныйЗвонок");
	ИначеЕсли ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
		ТипСобытия = ПредопределенноеЗначение("Перечисление.ТипыСобытий.ТелефонныйЗвонок");
	Иначе
		ТипСобытия = ПредопределенноеЗначение("Перечисление.ТипыСобытий.ПустаяСсылка");
	КонецЕсли;
	
	Возврат ТипСобытия;
	
КонецФункции

Процедура ЗначениеКИРедактированиеВДиалогеЗавершено(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеКИ = ДополнительныеПараметры.Форма.КонтактнаяИнформация[ДополнительныеПараметры.ИндексКИ];
	
	ДанныеКИ.Представление = РезультатЗакрытия.Представление;
	ДанныеКИ.Значение      = РезультатЗакрытия.Значение;
	ДанныеКИ.Комментарий   = РезультатЗакрытия.Комментарий;
	
	ДополнительныеПараметры.Форма.Модифицированность = Истина;
	
	Если ДанныеКИ.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		КонтактнаяИнформацияУНФКлиентСервер.ЗаполнитьСписокВыбораАдресов(ДополнительныеПараметры.Форма);
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ОповещениеОЗакрытииДиалога") Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытииДиалога, РезультатЗакрытия.Представление);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьКонтактнуюИнформациюВидВыбран(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	Отбор = Новый Структура("Вид", ВыбранныйЭлемент.Значение);
	
	НайденныеСтроки = Форма.СвойстваВидовКонтактнойИнформации.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	СвойстваВида = НайденныеСтроки[0];
	
	Если СвойстваВида.ВыводитьВФормеВсегда = Ложь Тогда
		
		ДополнительныеПараметры.Вставить("ДобавляемыйВид", ВыбранныйЭлемент.Значение);
		ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьКонтактнуюИнформациюВопросЗадан", ЭтотОбъект, ДополнительныеПараметры);
		
		ТекстВопроса = СтрШаблон(НСтр("ru='Добавить возможность ввода вида контактной информации ""%1""?'"), ВыбранныйЭлемент.Значение);
		ЗаголовокВопроса = НСтр("ru='Подтверждение добавления'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, ЗаголовокВопроса);
		
	Иначе
		
		Если ДополнительныеПараметры.Свойство("ИдентификаторСтрокиТабличнойЧасти") Тогда
			Форма.ДобавитьКонтактнуюИнформациюСервер(ВыбранныйЭлемент.Значение, Ложь, ДополнительныеПараметры.ИдентификаторСтрокиТабличнойЧасти);
		Иначе
			Форма.ДобавитьКонтактнуюИнформациюСервер(ВыбранныйЭлемент.Значение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьКонтактнуюИнформациюВопросЗадан(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Форма.ДобавитьКонтактнуюИнформациюСервер(ДополнительныеПараметры.ДобавляемыйВид, Истина);
	
КонецПроцедуры

Процедура ПредложитьЗапускSkypeЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеПараметры.Свойство("ЛогинSkype") Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйЭлемент.Значение = "Позвонить" Тогда
		Действие = "call";
	ИначеЕсли ВыбранныйЭлемент.Значение = "НачатьЧат" Тогда
		Действие = "chat";
	Иначе
		Возврат;
	КонецЕсли;
	
	СтрокаЗапуска = СтрШаблон("skype:%1?%2", ДополнительныеПараметры.ЛогинSkype, Действие);
	ОткрытьSkype(СтрокаЗапуска);
	
КонецПроцедуры

Процедура ПослеЗапускаПриложения(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	Возврат; // Процедура заглушка, т.к. НачатьЗапускПриложения требуется наличие обработчика оповещения.
КонецПроцедуры

// Проверяет, установлена ли программа телефонии на компьютер.
//  Проверка возможна только в тонком клиенте для Windows.
//
// Параметры:
//  ИмяПротокола - Строка - Имя проверяемого URI протокола, возможные варианты "skype", "tel", "sip".
//                          Если параметр не указан, то проверяются все протоколы. 
// 
// Возвращаемое значение:
//  Строка - имя доступного URI протокола зарегистрирована в реестре. Пустая строка - если протокол не доступен.
//  Неопределенно если проверка не возможна.
//
Функция ПрограммаТелефонииУстановлена(ИмяПротокола = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ЭтоWindowsКлиент() Тогда
		Если ЗначениеЗаполнено(ИмяПротокола) Тогда
			Возврат ?(ИмяПротоколаЗарегистрированоВРеестре(ИмяПротокола), ИмяПротокола, "");
		Иначе
			СписокПротоколов = Новый Массив;
			СписокПротоколов.Добавить("tel");
			СписокПротоколов.Добавить("sip");
			СписокПротоколов.Добавить("skype");
			Для каждого ИмяПротокола Из СписокПротоколов Цикл
				Если ИмяПротоколаЗарегистрированоВРеестре(ИмяПротокола) Тогда
					Возврат ИмяПротокола;
				КонецЕсли;
			КонецЦикла;
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	// Считаем что для Linux и MacOS всегда есть программа.
	// если будет ошибка - она будет обработана в момент запуска.
	Возврат ИмяПротокола;
	
КонецФункции

Функция ИмяПротоколаЗарегистрированоВРеестре(ИмяПротокола)
	
	ИмяПротоколаЗарегистрировано = Ложь;
	
#Если НЕ МобильныйКлиент Тогда
	Попытка
		Оболочка = Новый COMОбъект("Wscript.Shell");
		Результат = Оболочка.RegRead("HKEY_CLASSES_ROOT\" + ИмяПротокола + "\");
		ИмяПротоколаЗарегистрировано = Истина;
	Исключение
		ИмяПротоколаЗарегистрировано = Ложь;
	КонецПопытки;
#КонецЕсли
	
	Возврат ИмяПротоколаЗарегистрировано;
	
КонецФункции

#КонецОбласти
