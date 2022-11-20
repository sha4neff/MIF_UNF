
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Период = Параметры.Дата;
	Компания = Параметры.Компания;
	Контрагент = Параметры.Контрагент;
	ВалютаДенежныхСредств = Параметры.ВалютаДенежныхСредств;
	Ссылка = Параметры.Ссылка;
	ВидОперации = Параметры.ВидОперации;
	СуммаДокумента = Параметры.СуммаДокумента;
	
	Элементы.ОтобранныеДолгиДоговор.Видимость = Контрагент.ВестиРасчетыПоДоговорам;
	Элементы.ОтобранныеДолгиДокумент.Видимость = Контрагент.ВестиРасчетыПоДокументам;
	Элементы.ОтобранныеДолгиЗаказ.Видимость = Контрагент.ВестиРасчетыПоЗаказам;
	
	Элементы.СписокДолговДоговор.Видимость = Контрагент.ВестиРасчетыПоДоговорам;
	Элементы.СписокДолговДокумент.Видимость = Контрагент.ВестиРасчетыПоДокументам;
	Элементы.СписокДолговЗаказ.Видимость = Контрагент.ВестиРасчетыПоЗаказам;
	
	ВалютаУчета = Константы.ВалютаУчета.Получить();
	УчетВалютныхОпераций = Константы.ФункциональнаяУчетВалютныхОпераций.Получить();
	
	АдресРасшифровкаПлатежаВХранилище = Параметры.АдресРасшифровкаПлатежаВХранилище;
	ОтобранныеДолги.Загрузить(ПолучитьИзВременногоХранилища(АдресРасшифровкаПлатежаВХранилище));
	
	// Удаление строк с незаполненной суммой.
	МассивСтрокДляУдаления = Новый Массив;
	Для каждого ТекСтрока Из ОтобранныеДолги Цикл
		Если ТекСтрока.СуммаРасчетов = 0 Тогда
			МассивСтрокДляУдаления.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекЭлемент Из МассивСтрокДляУдаления Цикл
		ОтобранныеДолги.Удалить(ТекЭлемент);
	КонецЦикла;
	
	ФункциональнаяУчетВалютныхОпераций = Константы.ФункциональнаяУчетВалютныхОпераций.Получить();
	Элементы.СписокДолговКурс.Видимость = ФункциональнаяУчетВалютныхОпераций;
	Элементы.СписокДолговКратность.Видимость = ФункциональнаяУчетВалютныхОпераций;
	
	Элементы.Итоги.Видимость = НЕ УчетВалютныхОпераций;
	
	ЗаполнитьДолги();
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РассчитатьСуммаИтог();
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДолгов

// Процедура помещает результаты порезультат выбора в подбор.
//
&НаКлиенте
Процедура СписокДолговВыборЗначения(Элемент, СтандартнаяОбработка, Значение)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	
	СуммаРасчетов = ТекущаяСтрока.СуммаРасчетов;
	Если ЗапрашиватьСумму Тогда
		ПоказатьВводЧисла(Новый ОписаниеОповещения("СписокДолговВыборЗначенияЗавершение", ЭтотОбъект, Новый Структура("ТекущаяСтрока, СуммаРасчетов", ТекущаяСтрока, СуммаРасчетов)), СуммаРасчетов, "Введите сумму расчетов", , );
        Возврат;
	КонецЕсли;
	
	СписокДолговВыборЗначенияФрагмент(СуммаРасчетов, ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура СписокДолговВыборЗначенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ТекущаяСтрока = ДополнительныеПараметры.ТекущаяСтрока;
    СуммаРасчетов = ?(Результат = Неопределено, ДополнительныеПараметры.СуммаРасчетов, Результат);
    
    
    Если НЕ (Результат <> Неопределено) Тогда
        Возврат;
    КонецЕсли;
    
    СписокДолговВыборЗначенияФрагмент(СуммаРасчетов, ТекущаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура СписокДолговВыборЗначенияФрагмент(Знач СуммаРасчетов, Знач ТекущаяСтрока)
    
    Перем НоваяСтрока, Строки, СтруктураПоиска;
    
    ТекущаяСтрока.СуммаРасчетов = СуммаРасчетов;
    
    СтруктураПоиска = Новый Структура("Договор, Документ, Заказ", ТекущаяСтрока.Договор, ТекущаяСтрока.Документ, ТекущаяСтрока.Заказ);
    Строки = ОтобранныеДолги.НайтиСтроки(СтруктураПоиска);
    
    Если Строки.Количество() > 0 Тогда
        НоваяСтрока = Строки[0];
        НоваяСтрока.СуммаРасчетов = НоваяСтрока.СуммаРасчетов + СуммаРасчетов;
    Иначе 
        НоваяСтрока = ОтобранныеДолги.Добавить();
        ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
    КонецЕсли;
    
    Элементы.ОтобранныеДолги.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
    
    РассчитатьСуммаИтог();
    ЗаполнитьДолги();

КонецПроцедуры // СписокДолговВыборЗначения()

// Процедура - обработчик события НачалоПеретаскивания списка СписокДолгов.
//
&НаКлиенте
Процедура СписокДолговНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Структура = Новый Структура;
	Структура.Вставить("Документ", ТекущиеДанные.Документ);
	Структура.Вставить("Заказ", ТекущиеДанные.Заказ);
	Структура.Вставить("СуммаРасчетов", ТекущиеДанные.СуммаРасчетов);
	Структура.Вставить("Договор", ТекущиеДанные.Договор);
	Если ТекущиеДанные.Свойство("Курс") Тогда
		Структура.Вставить("Курс", ТекущиеДанные.Курс);
	КонецЕсли;
	Если ТекущиеДанные.Свойство("Кратность") Тогда
		Структура.Вставить("Кратность", ТекущиеДанные.Кратность);
	КонецЕсли;
	
	ПараметрыПеретаскивания.Значение = Структура;
	
	ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.Копирование;
	
КонецПроцедуры // СписокДолговНачалоПеретаскивания()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтобранныеДолги

// Процедура - обработчик события ПроверкаПеретаскивания списка ОтобранныеДолги.
//
&НаКлиенте
Процедура ОтобранныеДолгиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование;
	
КонецПроцедуры // ОтобранныеДолгиПроверкаПеретаскивания()

// Процедура - обработчик события ПроверкаПеретаскивания списка ОтобранныеДолги.
//
&НаКлиенте
Процедура ОтобранныеДолгиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыСтруктура = ПараметрыПеретаскивания.Значение;
	
	СуммаРасчетов = ПараметрыСтруктура.СуммаРасчетов;
	Если ЗапрашиватьСумму Тогда
		ПоказатьВводЧисла(Новый ОписаниеОповещения("ОтобранныеДолгиПеретаскиваниеЗавершение", ЭтотОбъект, Новый Структура("ПараметрыСтруктура, СуммаРасчетов", ПараметрыСтруктура, СуммаРасчетов)), СуммаРасчетов, "Введите сумму расчетов", , );
        Возврат;
	КонецЕсли;
	
	ОтобранныеДолгиПеретаскиваниеФрагмент(ПараметрыСтруктура, СуммаРасчетов);
КонецПроцедуры

&НаКлиенте
Процедура ОтобранныеДолгиПеретаскиваниеЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ПараметрыСтруктура = ДополнительныеПараметры.ПараметрыСтруктура;
    СуммаРасчетов = ?(Результат = Неопределено, ДополнительныеПараметры.СуммаРасчетов, Результат);
    
    
    Если НЕ (Результат <> Неопределено) Тогда
        Возврат;
    КонецЕсли;
    
    ОтобранныеДолгиПеретаскиваниеФрагмент(ПараметрыСтруктура, СуммаРасчетов);

КонецПроцедуры

&НаКлиенте
Процедура ОтобранныеДолгиПеретаскиваниеФрагмент(Знач ПараметрыСтруктура, Знач СуммаРасчетов)
    
    Перем НоваяСтрока, Строки, СтруктураПоиска;
    
    ПараметрыСтруктура.СуммаРасчетов = СуммаРасчетов;
    
    СтруктураПоиска = Новый Структура("Договор, Документ, Заказ", ПараметрыСтруктура.Договор, ПараметрыСтруктура.Документ, ПараметрыСтруктура.Заказ);
    Строки = ОтобранныеДолги.НайтиСтроки(СтруктураПоиска);
    
    Если Строки.Количество() > 0 Тогда
        НоваяСтрока = Строки[0];
        НоваяСтрока.СуммаРасчетов = НоваяСтрока.СуммаРасчетов + СуммаРасчетов;
    Иначе 
        НоваяСтрока = ОтобранныеДолги.Добавить();
        ЗаполнитьЗначенияСвойств(НоваяСтрока, ПараметрыСтруктура);
    КонецЕсли;
    
    Элементы.ОтобранныеДолги.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
    
    РассчитатьСуммаИтог();
    ЗаполнитьДолги();

КонецПроцедуры // ОтобранныеДолгиПеретаскивание()

// Процедура - обработчик события ПриИзменении списка ОтобранныеДолги.
//
&НаКлиенте
Процедура ОтобранныеДолгиПриИзменении(Элемент)
	
	РассчитатьСуммаИтог();
	ЗаполнитьДолги();
	
КонецПроцедуры // ОтобранныеДолгиПриИзменении()

// Процедура - обработчик события ПриНачалеРедактирования списка ОтобранныеДолги.
//
&НаКлиенте
Процедура ОтобранныеДолгиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Копирование Тогда
		РассчитатьСуммаИтог();
		ЗаполнитьДолги();
	КонецЕсли;
	
КонецПроцедуры // ОтобранныеАвансыПриНачалеРедактирования()

// Процедура - обработчик события ПередНачаломДобавления списка ОтобранныеДолги.
//
&НаКлиенте
Процедура ОтобранныеДолгиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры // ОтобранныеДолгиПередНачаломДобавления()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик нажатия кнопки Обновить.
//
&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьДолги();
	
КонецПроцедуры // Обновить()

// Процедура - обработчик нажатия кнопки ЗапрашиватьСумму.
//
&НаКлиенте
Процедура ЗапрашиватьСумму(Команда)
	
	ЗапрашиватьСумму = НЕ ЗапрашиватьСумму;
	Элементы.ЗапрашиватьСумму.Пометка = ЗапрашиватьСумму;
	
КонецПроцедуры // ЗапрашиватьСумму()

// Процедура - обработчик нажатия кнопки ЗаполнитьАвтоматически.
//
&НаКлиенте
Процедура ЗаполнитьАвтоматически(Команда)
	
	ЗаполнитьРасшифровкуПлатежа();
	РассчитатьСуммаИтог();
	ЗаполнитьДолги();
	
КонецПроцедуры // ЗаполнитьАвтоматически()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура рассчитывает итоговую сумму.
//
&НаКлиенте
Процедура РассчитатьСуммаИтог()
	
	СуммаИтог = 0;
	
	Для каждого ТекСтрока Из ОтобранныеДолги Цикл
		СуммаИтог = СуммаИтог + ТекСтрока.СуммаРасчетов;
	КонецЦикла;
	
КонецПроцедуры // РассчитатьСуммаИтог()

// Процедура - обработчик нажатия кнопки ОК.
//
&НаКлиенте
Процедура ОКВыполнить()
	
	ЗаписатьПодборВХранилище();
	Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры

// Процедура помещает результаты подбора в хранилище.
//
&НаСервере
Процедура ЗаписатьПодборВХранилище() 
	
	ТаблицаОтобранныеДолги = ОтобранныеДолги.Выгрузить();
	ПоместитьВоВременноеХранилище(ТаблицаОтобранныеДолги, АдресРасшифровкаПлатежаВХранилище);
	
КонецПроцедуры

// Процедура заполняет расшифровку платежа.
//
&НаСервере
Процедура ЗаполнитьРасшифровкуПлатежа()
	
	// Заполнение расшифровки расчетов по умолчанию.
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщикамиОстатки.Организация КАК Организация,
	|	РасчетыСПоставщикамиОстатки.Договор КАК Договор,
	|	РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|	РасчетыСПоставщикамиОстатки.ТипРасчетов КАК ТипРасчетов,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаОстаток) КАК СуммаОстаток,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) КАК СуммаВалОстаток,
	|	РасчетыСПоставщикамиОстатки.Документ.Дата КАК ДокументДата,
	|	СУММА(ВЫРАЗИТЬ(РасчетыСПоставщикамиОстатки.СуммаВалОстаток * КурсыВалютРасчетов.Курс * КурсыВалютДокумента.Кратность / (КурсыВалютДокумента.Курс * КурсыВалютРасчетов.Кратность) КАК ЧИСЛО(15, 2))) КАК СуммаВалДокумента,
	|	КурсыВалютДокумента.Курс КАК КурсДенежныхСредств,
	|	КурсыВалютДокумента.Кратность КАК КратностьДенежныхСредств,
	|	КурсыВалютРасчетов.Курс КАК Курс,
	|	КурсыВалютРасчетов.Кратность КАК Кратность
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.Организация КАК Организация,
	|		РасчетыСПоставщикамиОстатки.Договор КАК Договор,
	|		РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|		РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|		РасчетыСПоставщикамиОстатки.ТипРасчетов КАК ТипРасчетов,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками.Остатки(
	|				,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					// ТекстДоговорОтбор
	|					И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)) КАК РасчетыСПоставщикамиОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаРасчетыСПоставщиками.Организация,
	|		ДвиженияДокументаРасчетыСПоставщиками.Договор,
	|		ДвиженияДокументаРасчетыСПоставщиками.Документ,
	|		ДвиженияДокументаРасчетыСПоставщиками.Заказ,
	|		ДвиженияДокументаРасчетыСПоставщиками.ТипРасчетов,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками КАК ДвиженияДокументаРасчетыСПоставщиками
	|	ГДЕ
	|		ДвиженияДокументаРасчетыСПоставщиками.Регистратор = &Ссылка
	|		И ДвиженияДокументаРасчетыСПоставщиками.Период <= &Период
	|		И ДвиженияДокументаРасчетыСПоставщиками.Организация = &Организация
	|		И ДвиженияДокументаРасчетыСПоставщиками.Контрагент = &Контрагент
	|		И ДвиженияДокументаРасчетыСПоставщиками.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)) КАК РасчетыСПоставщикамиОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &Валюта) КАК КурсыВалютДокумента
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, ) КАК КурсыВалютРасчетов
	|		ПО РасчетыСПоставщикамиОстатки.Договор.ВалютаРасчетов = КурсыВалютРасчетов.Валюта
	|ГДЕ
	|	РасчетыСПоставщикамиОстатки.СуммаВалОстаток > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщикамиОстатки.Организация,
	|	РасчетыСПоставщикамиОстатки.Договор,
	|	РасчетыСПоставщикамиОстатки.Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ,
	|	РасчетыСПоставщикамиОстатки.ТипРасчетов,
	|	РасчетыСПоставщикамиОстатки.Документ.Дата,
	|	КурсыВалютДокумента.Курс,
	|	КурсыВалютДокумента.Кратность,
	|	КурсыВалютРасчетов.Курс,
	|	КурсыВалютРасчетов.Кратность
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументДата";
		
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Валюта", ВалютаДенежныхСредств);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	НуженОтборПоДоговорам = УправлениеНебольшойФирмойПовтИсп.ТребуетсяКонтрольДоговоровКонтрагентов();
	СписокВидовДоговоров = Справочники.ДоговорыКонтрагентов.ПолучитьСписокВидовДоговораДляДокумента(Ссылка, ВидОперации);
	Если Контрагент.ВестиРасчетыПоДоговорам
	   И НуженОтборПоДоговорам Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "// ТекстДоговорОтбор", "И Договор.ВидДоговора В (&СписокВидовДоговоров)");
		Запрос.УстановитьПараметр("СписокВидовДоговоров", СписокВидовДоговоров);
	КонецЕсли;
	
	ДоговорПоУмолчанию = Справочники.ДоговорыКонтрагентов.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(
		Контрагент,
		Компания,
		СписокВидовДоговоров
	);
	
	СтруктураКурсВалютыДоговораПоУмолчанию = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(
		Период,
		Новый Структура("Валюта", ДоговорПоУмолчанию.ВалютаРасчетов)
	);
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	ОтобранныеДолги.Очистить();
	
	СуммаОсталосьРаспределить = СуммаДокумента;
	
	СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Период, Новый Структура("Валюта", ВалютаДенежныхСредств));
	
	Курс = ?(
		СтруктураПоВалюте.Курс = 0,
		1,
		СтруктураПоВалюте.Курс
	);
	Кратность = ?(
		СтруктураПоВалюте.Курс = 0,
		1,
		СтруктураПоВалюте.Кратность
	);
	
	Пока СуммаОсталосьРаспределить > 0 Цикл
		
		НоваяСтрока = ОтобранныеДолги.Добавить();
		
		Если ВыборкаРезультатаЗапроса.Следующий() Тогда
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
			
			Если ВыборкаРезультатаЗапроса.СуммаВалДокумента <= СуммаОсталосьРаспределить Тогда // сумма остатка меньше или равна чем осталось распределить
				
				НоваяСтрока.СуммаРасчетов = ВыборкаРезультатаЗапроса.СуммаВалОстаток;
				СуммаОсталосьРаспределить = СуммаОсталосьРаспределить - ВыборкаРезультатаЗапроса.СуммаВалДокумента;
				
			Иначе // сумма остатка больше чем нужно распределить
				
				НоваяСтрока.СуммаРасчетов = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
					СуммаОсталосьРаспределить,
					ВыборкаРезультатаЗапроса.КурсДенежныхСредств,
					ВыборкаРезультатаЗапроса.Курс,
					ВыборкаРезультатаЗапроса.КратностьДенежныхСредств,
					ВыборкаРезультатаЗапроса.Кратность
				);
				СуммаОсталосьРаспределить = 0;
				
			КонецЕсли;
			
		Иначе
			
			НоваяСтрока.Договор = ДоговорПоУмолчанию;
			НоваяСтрока.Курс = ?(
				СтруктураКурсВалютыДоговораПоУмолчанию.Курс = 0,
				1,
				СтруктураКурсВалютыДоговораПоУмолчанию.Курс
			);
			НоваяСтрока.Кратность = ?(
				СтруктураКурсВалютыДоговораПоУмолчанию.Кратность = 0,
				1,
				СтруктураКурсВалютыДоговораПоУмолчанию.Кратность
			);
			НоваяСтрока.СуммаРасчетов = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
				СуммаОсталосьРаспределить,
				Курс,
				НоваяСтрока.Курс,
				Кратность,
				НоваяСтрока.Кратность
			);
			НоваяСтрока.ПризнакАванса = Истина;
			СуммаОсталосьРаспределить = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьРасшифровкуПлатежа()

// Процедура заполняет список долгов.
//
&НаСервере
Процедура ЗаполнитьДолги()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&Организация,
	|	ОтобранныеДолги.Договор,
	|	ОтобранныеДолги.Документ,
	|	ВЫБОР
	|		КОГДА ОтобранныеДолги.Заказ = НЕОПРЕДЕЛЕНО
	|			ТОГДА ЗНАЧЕНИЕ(Документ.ЗаказПоставщику.ПустаяСсылка)
	|		ИНАЧЕ ОтобранныеДолги.Заказ
	|	КОНЕЦ КАК Заказ,
	|	ОтобранныеДолги.СуммаРасчетов
	|ПОМЕСТИТЬ ТаблицаОтобранныеДолги
	|ИЗ
	|	&ТаблицаОтобранныеДолги КАК ОтобранныеДолги
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщикамиОстатки.Организация КАК Организация,
	|	РасчетыСПоставщикамиОстатки.Договор КАК Договор,
	|	РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) КАК СуммаРасчетов,
	|	РасчетыСПоставщикамиОстатки.Документ.Дата КАК ДокументДата,
	|	КурсыВалютРасчетов.Курс КАК Курс,
	|	КурсыВалютРасчетов.Кратность КАК Кратность
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.Организация КАК Организация,
	|		РасчетыСПоставщикамиОстатки.Договор КАК Договор,
	|		РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|		РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками.Остатки(
	|				,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					// ТекстДоговорОтбор
	|					И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)) КАК РасчетыСПоставщикамиОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&Организация,
	|		ОтобранныеДолги.Договор,
	|		ОтобранныеДолги.Документ,
	|		ОтобранныеДолги.Заказ,
	|		-ОтобранныеДолги.СуммаРасчетов
	|	ИЗ
	|		ТаблицаОтобранныеДолги КАК ОтобранныеДолги
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаРасчетыСПоставщиками.Организация,
	|		ДвиженияДокументаРасчетыСПоставщиками.Договор,
	|		ДвиженияДокументаРасчетыСПоставщиками.Документ,
	|		ДвиженияДокументаРасчетыСПоставщиками.Заказ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками КАК ДвиженияДокументаРасчетыСПоставщиками
	|	ГДЕ
	|		ДвиженияДокументаРасчетыСПоставщиками.Регистратор = &Ссылка
	|		И ДвиженияДокументаРасчетыСПоставщиками.Период <= &Период
	|		И ДвиженияДокументаРасчетыСПоставщиками.Организация = &Организация
	|		И ДвиженияДокументаРасчетыСПоставщиками.Контрагент = &Контрагент
	|		И ДвиженияДокументаРасчетыСПоставщиками.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)) КАК РасчетыСПоставщикамиОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, ) КАК КурсыВалютРасчетов
	|		ПО РасчетыСПоставщикамиОстатки.Договор.ВалютаРасчетов = КурсыВалютРасчетов.Валюта
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщикамиОстатки.Организация,
	|	РасчетыСПоставщикамиОстатки.Договор,
	|	РасчетыСПоставщикамиОстатки.Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ,
	|	РасчетыСПоставщикамиОстатки.Документ.Дата,
	|	КурсыВалютРасчетов.Курс,
	|	КурсыВалютРасчетов.Кратность
	|
	|ИМЕЮЩИЕ
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументДата";
	
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Валюта", ВалютаДенежныхСредств);
	Запрос.УстановитьПараметр("ТаблицаОтобранныеДолги", ОтобранныеДолги.Выгрузить());
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	НуженОтборПоДоговорам = УправлениеНебольшойФирмойПовтИсп.ТребуетсяКонтрольДоговоровКонтрагентов();
	Если Контрагент.ВестиРасчетыПоДоговорам
	   И НуженОтборПоДоговорам Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "// ТекстДоговорОтбор", "И Договор.ВидДоговора В (&СписокВидовДоговоров)");
		Запрос.УстановитьПараметр("СписокВидовДоговоров", Справочники.ДоговорыКонтрагентов.ПолучитьСписокВидовДоговораДляДокумента(Ссылка, ВидОперации));
	КонецЕсли;
	
	СписокДолгов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры // ЗаполнитьДолги()

#КонецОбласти
