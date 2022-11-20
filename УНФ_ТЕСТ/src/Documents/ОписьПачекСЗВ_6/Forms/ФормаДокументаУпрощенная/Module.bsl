
&НаКлиенте
Процедура ПачкиДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не ТолькоПросмотр И Поле.Имя = "ПачкиДокументовДокумент" Тогда
		ТекущиеДанныеСтроки = Элементы.ПачкиДокументов.ТекущиеДанные;
		Если ТекущиеДанныеСтроки <> Неопределено Тогда
			ПоказатьЗначение(,ТекущиеДанныеСтроки.ПачкаДокументов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ НА СЕРВЕРЕ БЕЗ КОНТЕКСТА


&НаСервереБезКонтекста
Функция ПолучитьНомерПачки(Документ)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "НомерПачки");
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ НА СЕРВЕРЕ


&НаСервере
Процедура ЗаполнитьНомераПачекНаСервере()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОписьПачекСЗВ_6ПачкиДокументов.НомерСтроки,
	               |	ОписьПачекСЗВ_6ПачкиДокументов.ПачкаДокументов,
	               |	ЕСТЬNULL(ОписьПачекСЗВ_6ПачкиДокументов.ПачкаДокументов.НомерПачки, 0) КАК НомерПачки
	               |ИЗ
	               |	Документ.ОписьПачекСЗВ_6.ПачкиДокументов КАК ОписьПачекСЗВ_6ПачкиДокументов
	               |ГДЕ
	               |	ОписьПачекСЗВ_6ПачкиДокументов.Ссылка = &Ссылка
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ОписьПачекСЗВ_6ПачкиДокументов.НомерСтроки";
	
	Объект.ПачкиДокументов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры	



////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ (НА КЛИЕНТЕ)

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьНомераПачекНаСервере();
	ОтчетныйПериодСтрока = УчетСтраховыхВзносов.ПредставлениеОтчетногоПериода(Объект.ОтчетныйПериод);
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ОчиститьСообщения();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьНомераПачекНаСервере();
КонецПроцедуры


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ЗаполнитьНомераПачекНаСервере();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ШАПКИ

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНД

&НаКлиенте
Процедура ПачкиДокументовДокументПриИзменении(Элемент)
	СтрокаПачекДокументов = Объект.ПачкиДокументов.НайтиПоИдентификатору(Элементы.ПачкиДокументов.ТекущиеДанные.ПолучитьИдентификатор());
	
	СтрокаПачекДокументов.НомерПачки = ПолучитьНомерПачки(СтрокаПачекДокументов.ПачкаДокументов);
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьПечатнуюФорму(Команда)
	
	Если Модифицированность И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Объект.Ссылка);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ОписьПачекСЗВ_6", "ФормаАДВ_6_2", МассивОбъектов, ЭтаФорма, Новый Структура());
	
КонецПроцедуры













#КонецОбласти
