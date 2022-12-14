
#Область ОписаниеПеременных

&НаКлиенте
Перем УдаляемыеСтроки;

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ (НА СЕРВЕРЕ БЕЗ КОНТЕКСТА)


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ НА СЕРВЕРЕ

&НаСервере
Функция ПроверитьЗаполнениеНаСервере()Экспорт
	ДокументОбъект = РеквизитФормыВЗначение ("Объект", Тип("ДокументОбъект.РеестрСЗВ_6_2"));
	Возврат ДокументОбъект.ПроверитьЗаполнение();
КонецФункции

&НаСервере
Процедура ОбработкаПодбораНаСервере(МассивСотрудников)
	ДокументыСЗВОбработкаПодбораНаСервере(Объект, МассивСотрудников, Истина);
КонецПроцедуры

&НаСервере
Процедура СотрудникиСотрудникПриИзмененииНаСервере()
	
	ДокументыСЗВСотрудникПриИзменении(Элементы.Сотрудники, Объект, ТекущийСотрудник, Истина);	
	
КонецПроцедуры

&НаСервере
Процедура ДокументыСЗВСотрудникПриИзменении(ЭлентФормыСотрудники, ДокументОбъект, ТекущийСотрудник, УчитыватьКорректируемыйПериод = Истина)Экспорт 
	Если Не УчитыватьКорректируемыйПериод Тогда
		КорректируемыйПериод = ДокументОбъект.ОтчетныйПериод;
	Иначе
		КорректируемыйПериод = ДокументОбъект.КорректируемыйПериод;
	КонецЕсли;
	
	ИдентификаторТекущейСтроки = ЭлентФормыСотрудники.ТекущаяСтрока;
	ДанныеТекущейСтроки = ДокументОбъект.Сотрудники.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		НовыйСотрудник = ДанныеТекущейСтроки.Сотрудник;
		Если ТекущийСотрудник <> НовыйСотрудник Тогда
			УдалитьСтрокиТаблицыЗаписиОСтажеНаСервере(ДокументОбъект.ЗаписиОСтаже, ТекущийСотрудник);
			ТекущийСотрудник = НовыйСотрудник;
			УчетСтраховыхВзносов.ДокументыСЗВЗаполнитьДанныеСотрудника(ДокументОбъект.Ссылка, ДокументОбъект.Дата, ДокументОбъект.ТипСведенийСЗВ, ДокументОбъект.ОтчетныйПериод, КорректируемыйПериод, ДокументОбъект.Организация, ДокументОбъект.КатегорияЗастрахованныхЛиц, ТекущийСотрудник, ЭлентФормыСотрудники.ТекущаяСтрока, ДокументОбъект.Сотрудники, ДокументОбъект.ЗаписиОСтаже);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокиТаблицыЗаписиОСтажеНаСервере(ЗаписиОСтаже, Сотрудник) Экспорт
	УдаляемыеСтрокиТаблицы = ЗаписиОСтаже.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтрокиТаблицы Цикл
		ЗаписиОСтаже.Удалить(ЗаписиОСтаже.Индекс(УдаляемаяСтрока));
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтрокиТаблицыЗаписиОСтаже(ЗаписиОСтаже, Сотрудник) Экспорт
	УдаляемыеСтрокиТаблицы = ЗаписиОСтаже.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтрокиТаблицы Цикл
		ЗаписиОСтаже.Удалить(ЗаписиОСтаже.Индекс(УдаляемаяСтрока));
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДокументыРедактированияСтажаУстановитьОтборЗаписейОСтажеНаСервере(ЭлементФормыЗаписиОСтаже, Сотрудник) Экспорт 
	СтруктураОтбора = Новый ФиксированнаяСтруктура("Сотрудник", Сотрудник);
	ЭлементФормыЗаписиОСтаже.ОтборСтрок = СтруктураОтбора;
КонецПроцедуры

&НаСервере
Процедура ДокументыСЗВОбработкаПодбораНаСервере(ДокументОбъект, МассивСотрудников, УчитыватьКорректируемыйПериод = Истина)Экспорт
	
	Если Не УчитыватьКорректируемыйПериод Тогда
		КорректируемыйПериод = ДокументОбъект.ОтчетныйПериод;
	Иначе
		КорректируемыйПериод = ДокументОбъект.КорректируемыйПериод;
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура("Сотрудник");	
	Корректировка = ДокументОбъект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ;
	ВыборкаДанныхСотрудников =УчетСтраховыхВзносов.ПолучитьДанныеПоСпискуФизЛицДляСЗВ(ДокументОбъект.Ссылка, ДокументОбъект.Дата, ?(Корректировка, КорректируемыйПериод, ДокументОбъект.ОтчетныйПериод), ДокументОбъект.Организация, ДокументОбъект.КатегорияЗастрахованныхЛиц, МассивСотрудников, Корректировка).Выбрать();	
	Пока ВыборкаДанныхСотрудников.СледующийПоЗначениюПоля("Сотрудник") Цикл
		СтруктураПоиска.Сотрудник = ВыборкаДанныхСотрудников.Сотрудник;
		Если ДокументОбъект.Сотрудники.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда 
			НоваяСтрокаСотрудник = ДокументОбъект.Сотрудники.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаСотрудник, ВыборкаДанныхСотрудников);
			ПериодыСтажаПредставление = "";
			Если ЗначениеЗаполнено(ВыборкаДанныхСотрудников.ДатаНачалаПериода) Тогда
				МассивСтрокСтажа = Новый Массив;
				Пока ВыборкаДанныхСотрудников.СледующийПоЗначениюПоля("ДатаНачалаПериода") Цикл
					НоваяСтрокаЗаписиОСтаже = ДокументОбъект.ЗаписиОСтаже.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаЗаписиОСтаже, ВыборкаДанныхСотрудников);
					МассивСтрокСтажа.Добавить(НоваяСтрокаЗаписиОСтаже);
					ПериодыСтажаПредставление = ПериодыСтажаПредставление + Формат(ВыборкаДанныхСотрудников.ДатаНачалаПериода, "ДФ=dd.MM.yy") + Символы.НПП + "-" + Символы.НПП + Формат(ВыборкаДанныхСотрудников.ДатаОкончанияПериода, "ДФ=dd.MM.yy") + Символы.ПС;
				КонецЦикла;
				
				Если НоваяСтрокаЗаписиОСтаже.Свойство("НомерОсновнойЗаписи") Тогда
					ПерсонифицированныйУчетКлиентСервер.ВыполнитьНумерациюЗаписейОСтаже(МассивСтрокСтажа);
				КонецЕсли;
				
			КонецЕсли;
			Если НоваяСтрокаСотрудник.Свойство("ПериодыСтажаСтрока") Тогда
				НоваяСтрокаСотрудник.ПериодыСтажаСтрока = ПериодыСтажаПредставление;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ (НА КЛИЕНТЕ)

&НаКлиенте
Процедура ОткрытьФормуРедактированияПериодовСтажа(Элемент)	
	Сотрудник = Элементы.Сотрудники.ТекущиеДанные.Сотрудник;
	СтруктураПоиска = Новый Структура("Сотрудник", Сотрудник);
	НайденныеСтрокиСтажа = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска); 
	УдаляемыеСтроки = НайденныеСтрокиСтажа;
				
	МассивЗаписейСтажа = Новый Массив;
	
	Для Каждого СтрокаСтажаСотрудника Из НайденныеСтрокиСтажа Цикл
		СтруктураСтажа = Новый Структура("ДатаНачалаПериода, ДатаОкончанияПериода", СтрокаСтажаСотрудника.ДатаНачалаПериода, СтрокаСтажаСотрудника.ДатаОкончанияПериода);
		
		МассивЗаписейСтажа.Добавить(СтруктураСтажа);
	КонецЦикла;
	
	СтруктураПараметровФормы = Новый Структура("МассивЗаписейСтажа", МассивЗаписейСтажа);
	
	ФормаРедактированияСтажа = ПолучитьФорму("Документ.РеестрСЗВ_6_2.Форма.ФормаРедактированияСтажа", СтруктураПараметровФормы, Элемент);
	
	ФормаРедактированияСтажа.Открыть();
	
КонецПроцедуры	

&НаКлиенте
Процедура ОбработатьВыборПериодаСтажа(ВыбранноеЗначение)
	ПериодыСтажаПредставление = "";
	
	Сотрудник = Элементы.Сотрудники.ТекущиеДанные.Сотрудник;
	Если ВыбранноеЗначение <> Неопределено Тогда
		Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
			Объект.ЗаписиОСтаже.Удалить(Объект.ЗаписиОСтаже.Индекс(УдаляемаяСтрока));
		КонецЦикла;	
		
		Для Каждого ДобавляемаяСтрока Из ВыбранноеЗначение.ДобавляемыеСтроки Цикл
			СтрокаСтаж = Объект.ЗаписиОСтаже.Добавить();
			СтрокаСтаж.Сотрудник = Сотрудник;
			ЗаполнитьЗначенияСвойств(СтрокаСтаж, ДобавляемаяСтрока);
			
			ПериодыСтажаПредставление = ПериодыСтажаПредставление + Формат(СтрокаСтаж.ДатаНачалаПериода, "ДФ=dd.MM.yy") + Символы.НПП + "-" + Символы.НПП + Формат(СтрокаСтаж.ДатаОкончанияПериода, "ДФ=dd.MM.yy") + Символы.ПС;
		КонецЦикла;	
		Модифицированность = (Модифицированность Или ВыбранноеЗначение.Модифицированность);
	КонецЕсли;
	
	СтрокаСотрудники = Элементы.Сотрудники.ТекущиеДанные;
	СтрокаСотрудники.ПериодыСтажаСтрока = ПериодыСтажаПредставление;
	СтрокаСотрудники.ФиксСтаж = СтрокаСотрудники.ФиксСтаж Или ВыбранноеЗначение.Модифицированность;
	
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
		Объект.КорректируемыйПериод = '00010101';
		
		Элементы.СотрудникиНачисленоСтраховая.Видимость = Истина;
		Элементы.СотрудникиУплаченоСтраховая.Видимость = Истина;
		
		Элементы.СотрудникиНачисленоНакопительная.Видимость = Истина;
		Элементы.СотрудникиУплаченоНакопительная.Видимость = Истина;
		
		Элементы.СотрудникиДоначисленоНакопительная.Видимость = Ложь;
		Элементы.СотрудникиДоначисленоСтраховая.Видимость     = Ложь;
		
		Элементы.СотрудникиДоуплаченоНакопительная.Видимость = Ложь;
		Элементы.СотрудникиДоуплаченоСтраховая.Видимость     = Ложь;
	Иначе
		Если Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ Тогда
			Элементы.СотрудникиНачисленоСтраховая.Видимость = Истина;
			Элементы.СотрудникиУплаченоСтраховая.Видимость = Истина;
			
			Элементы.СотрудникиНачисленоНакопительная.Видимость = Истина;
			Элементы.СотрудникиУплаченоНакопительная.Видимость = Истина;
			
			Элементы.СотрудникиДоначисленоНакопительная.Видимость = Истина;
			Элементы.СотрудникиДоначисленоСтраховая.Видимость     = Истина;
			
			Элементы.СотрудникиДоуплаченоНакопительная.Видимость = Истина;
			Элементы.СотрудникиДоуплаченоСтраховая.Видимость     = Истина;
		Иначе
			Элементы.СотрудникиНачисленоСтраховая.Видимость = Ложь;
			Элементы.СотрудникиУплаченоСтраховая.Видимость = Ложь;
			
			Элементы.СотрудникиНачисленоНакопительная.Видимость = Ложь;
			Элементы.СотрудникиУплаченоНакопительная.Видимость = Ложь;
			
			Элементы.СотрудникиДоначисленоНакопительная.Видимость = Ложь;
			Элементы.СотрудникиДоначисленоСтраховая.Видимость     = Ложь;
			
			Элементы.СотрудникиДоуплаченоНакопительная.Видимость = Ложь;
			Элементы.СотрудникиДоуплаченоСтраховая.Видимость     = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	КоллекцияИменРеквизитовСодержащихАдрес.Добавить("АдресДляИнформирования");
	ОтчетныйПериодСтрока = УчетСтраховыхВзносов.ПредставлениеОтчетногоПериода(Объект.ОтчетныйПериод);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Элементы.Сотрудники.ТекущиеДанные = Неопределено Тогда
		ЗаписиОСтажеТекст = Нстр("ru = 'Записи о стаже:'"); 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ОчиститьСообщения();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Объект.ФайлСформирован И Не ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьЗаполнениеНаСервере();
	КонецЕсли;
КонецПроцедуры



&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеДанныхФизическогоЛица" Тогда
		СтруктураОтбора = Новый Структура("Сотрудник", Источник);
		СтрокиПоСотруднику = Объект.Сотрудники.НайтиСтроки(СтруктураОтбора);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ШАПКИ

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Если Записать(Новый Структура("РежимЗаписи ",РежимЗаписиДокумента.Проведение)) Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНД

&НаКлиенте
Процедура ПосмотретьПечатнуюФорму(Команда)
	
	Если Модифицированность И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Объект.Ссылка);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.РеестрСЗВ_6_2", "ФормаСЗВ_6_2", МассивОбъектов, ЭтаФорма, Новый Структура());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ "СОТРУДНИКИ"

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ОбработатьВыборПериодаСтажа(ВыбранноеЗначение);
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		ОбработкаПодбораНаСервере(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	
	УдаляемыеСтроки = Элементы.Сотрудники.ВыделенныеСтроки;
	Для Каждого Идентификатор Из УдаляемыеСтроки Цикл
		СтрокаСотрудник = Объект.Сотрудники.НайтиПоИдентификатору(Идентификатор);
		Если СтрокаСотрудник <> Неопределено Тогда 
			УдалитьСтрокиТаблицыЗаписиОСтаже(Объект.ЗаписиОСтаже, СтрокаСотрудник.Сотрудник);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Не ТолькоПросмотр И Поле.Имя = "ПериодыСтажа" Тогда
		ОткрытьФормуРедактированияПериодовСтажа(Элемент);
	ИначеЕсли Не ТолькоПросмотр И Поле.Имя = "СотрудникиФизическоеЛицо" Тогда
		ТекущиеДанныеСтроки = Элементы.Сотрудники.ТекущиеДанные;
		Если ТекущиеДанныеСтроки <> Неопределено Тогда
			ПоказатьЗначение(,ТекущиеДанныеСтроки.Сотрудник);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиФизическоеЛицоПриИзменении(Элемент)
	СотрудникиСотрудникПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СотрудникиПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанныеСтроки = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанныеСтроки <> Неопределено Тогда
		ТекущийСотрудник = ТекущиеДанныеСтроки.Сотрудник;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
