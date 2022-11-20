////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры и функции для копирования и вставки 
// строк табличных частей
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет возможность копирования строк в буфер обмена.
//
// Параметры:
//  ТЧ              - ДанныеФормыКоллекция - Таблица формы, в которой происходит копирование строк.
//  ТекущиеДанныеТЧ - ДанныеФормыЭлементКоллекции - Текущие данные таблицы.
// Возвращаемое значение:
//  Булево - Истина, если копирование строк возможно.
Функция МожноКопироватьСтроки(ТЧ, ТекущиеДанныеТЧ) Экспорт
	
	Если ТекущиеДанныеТЧ <> Неопределено И ТЧ.Количество() <> 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Оповещает пользователя о количестве скопированных строк в буфер обмена.
//
// Параметры:
//  КоличествоСкопированных - Число - Количество скопированных строк.
Процедура ОповеститьПользователяОКопированииСтрок(КоличествоСкопированных) Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru='Строки скопированы'"),,
		СтрШаблон(
			НСтр("ru='В буфер обмена скопированы строки (%1)'"),
			КоличествоСкопированных),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("БуферОбменаТабличнаяЧастьКопированиеСтрок");
	
КонецПроцедуры

// Оповещает пользователя о количестве вставленных строк в таблицу из буфера обмена.
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения - Форма, на которой располагается таблица.
//  КоличествоСкопированных - Число - Количество скопированных строк.
//  КоличествоСкопированных - Число - Количество вставленных строк.
Процедура ОповеститьПользователяОВставкеСтрок(КоличествоСкопированных, КоличествоВставленных) Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru='Строки вставлены'"),,
		СтрШаблон(
			НСтр("ru='Из буфера обмена вставлены строки (%1 из %2)'"),
			КоличествоВставленных,
			КоличествоСкопированных),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Обработчик события "ОбработкаОповещения" формы.
//
// Параметры:
//  Элементы - ВсеЭлементыФормы - Элементы формы, на которой расположены кнопки копирования и вставки строк.
//  ИмяТЧ    - Строка - Имя таблицы формы, в которой буду производиться встака/копирование строк.
Процедура ОбработкаОповещения(Элементы, ИмяТЧ) Экспорт
	
	УстановитьВидимостьКнопок(Элементы, ИмяТЧ, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Устанавливает доступность кнопок вставки и копирования строк в табличную часть.
Процедура УстановитьВидимостьКнопок(ЭлементыФормы, ИмяТЧ, ЕстьСкопированныеСтроки)
	
	ЭлементыФормы[ИмяТЧ + "КопироватьСтроки"].Доступность = Истина;
	
	Если ЕстьСкопированныеСтроки Тогда
		ЭлементыФормы[ИмяТЧ + "ВставитьСтроки"].Доступность = Истина;
	Иначе
		ЭлементыФормы[ИмяТЧ + "ВставитьСтроки"].Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
