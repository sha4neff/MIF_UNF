#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация = Параметры.Организация;
	АдресРасшифровкиПлатежаВХранилище = Параметры.АдресРасшифровкиПлатежаВХранилище;
	ИдентификаторФормыДокумента = Параметры.ИдентификаторФормыДокумента;
	ВидОперации = Параметры.ВидОперации;
	Если (ВидОперации = Перечисления.ВидыОперацийПоступлениеВКассу.ВозвратЗаймаСотрудником ИЛИ
		ВидОперации = Перечисления.ВидыОперацийПоступлениеНаСчет.ВозвратЗаймаСотрудником)
		И Параметры.Свойство("Сотрудник") Тогда
		Контрагент = Параметры.Сотрудник;
	Иначе
		Контрагент = Параметры.Контрагент;
	КонецЕсли;
	Дата = Параметры.Дата;
	Регистратор = Параметры.Регистратор;
	Ссылка = Параметры.Регистратор;
	ДоговорКредитаЗайма = Параметры.ДоговорКредитаЗайма;
	Валюта = Параметры.Валюта;
	СуммаДокумента = Параметры.СуммаДокумента;
	СтавкаНДСПоУмолчанию = Параметры.СтавкаНДСПоУмолчанию;
	СуммаПлатежа = Параметры.СуммаПлатежа;
	КурсПлатежа = Параметры.Курс;
	КратностьПлатежа = Параметры.Кратность;
	
	ТекущийЗаголовок = ""+Параметры.ВидОперации+?(ТипЗнч(Контрагент) = Тип("СправочникСсылка.Контрагенты"), ". Контрагент: ", ". Сотрудник: ")+
		Контрагент.Наименование+". Сумма: "+СуммаДокумента+" ("+Валюта+")";
	Элементы.ДекорацияИнформацияПоДокументу.Заголовок = ТекущийЗаголовок;
	
	ТекущийЗаголовок = ""+Параметры.ДоговорКредитаЗайма+". Сумма: "+Параметры.ДоговорКредитаЗайма.СуммаДокумента+" ("+Параметры.ДоговорКредитаЗайма.ВалютаРасчетов+")";
	Элементы.ДекорацияНадписьИнформацияПоДоговоруКредитаЗайма.Заголовок = ТекущийЗаголовок;
	Заголовок = "";
	
	ОчищатьТабличнуюЧастьПриЗаполнении = Истина;
	
	ЗаполнитьИнформациюПоКредитуЗаймуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды Заполнить формы.
//
&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьНаСервереПоДаннымТаблицы();
	
	Структура = Новый Структура("АдресРасшифровкиПлатежаВХранилище, ОчищатьТабличнуюЧастьПриЗаполнении", АдресРасшифровкиПлатежаВХранилище, ОчищатьТабличнуюЧастьПриЗаполнении);
	
	ОповеститьОВыборе(Структура);
	
КонецПроцедуры

// Процедура - обработчик команды Обновить формы.
//
&НаКлиенте
Процедура Обновить(Команда)
	
	ДанныеПлатежа.Очистить();
	ЗаполнитьИнформациюПоКредитуЗаймуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура формирует таблицу для заполнения табличной части РасшифровкаПлатежа документа и сохраняет ее во временном хранилище.
//
&НаСервере
Процедура ЗаполнитьНаСервереПоДаннымТаблицы()
	
	РасшифровкаПлатежа = Ссылка.РасшифровкаПлатежа.ВыгрузитьКолонки();
	
	Если СуммаДокумента = 0 ИЛИ Не ОчищатьТабличнуюЧастьПриЗаполнении Тогда
		
		Для Каждого ТекущаяСтрокаДанныхПлатежа Из ДанныеПлатежа Цикл
			Если Не ТекущаяСтрокаДанныхПлатежа.Отметка Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаполнитьСтрокуРасшифровкиПлатежаПоКредитамИЗаймам(РасшифровкаПлатежа, Перечисления.ТипыСуммГрафикаКредитовИЗаймов.Проценты, ТекущаяСтрокаДанныхПлатежа.СуммаПроцентов);
			ЗаполнитьСтрокуРасшифровкиПлатежаПоКредитамИЗаймам(РасшифровкаПлатежа, Перечисления.ТипыСуммГрафикаКредитовИЗаймов.Комиссия, ТекущаяСтрокаДанныхПлатежа.СуммаКомиссии);
			ЗаполнитьСтрокуРасшифровкиПлатежаПоКредитамИЗаймам(РасшифровкаПлатежа, Перечисления.ТипыСуммГрафикаКредитовИЗаймов.ОсновнойДолг, ТекущаяСтрокаДанныхПлатежа.СуммаОсновногоДолга);
			
		КонецЦикла;
		
	Иначе
		
		ОстатокСуммыКРаспределению = СуммаДокумента * КурсПлатежа * КратностьРасчетов / (КурсРасчетов * КратностьПлатежа);
		
		Для Каждого ТекущаяСтрокаДанныхПлатежа Из ДанныеПлатежа Цикл
			Если Не ТекущаяСтрокаДанныхПлатежа.Отметка Тогда
				Продолжить;
			КонецЕсли;
			
			СуммаПроцентов = Мин(ОстатокСуммыКРаспределению, ТекущаяСтрокаДанныхПлатежа.СуммаПроцентов);
			ОстатокСуммыКРаспределению = Макс(0, ОстатокСуммыКРаспределению - СуммаПроцентов);
			ЗаполнитьСтрокуРасшифровкиПлатежаПоКредитамИЗаймам(РасшифровкаПлатежа, Перечисления.ТипыСуммГрафикаКредитовИЗаймов.Проценты, СуммаПроцентов);
			
			СуммаКомиссии = Мин(ОстатокСуммыКРаспределению, ТекущаяСтрокаДанныхПлатежа.СуммаКомиссии);
			ОстатокСуммыКРаспределению = Макс(0, ОстатокСуммыКРаспределению - СуммаКомиссии);
			ЗаполнитьСтрокуРасшифровкиПлатежаПоКредитамИЗаймам(РасшифровкаПлатежа, Перечисления.ТипыСуммГрафикаКредитовИЗаймов.Комиссия, СуммаКомиссии);
			
			СуммаОсновногоДолга = Мин(ОстатокСуммыКРаспределению, ТекущаяСтрокаДанныхПлатежа.СуммаОсновногоДолга);
			ОстатокСуммыКРаспределению = Макс(0, ОстатокСуммыКРаспределению - СуммаОсновногоДолга);
			ЗаполнитьСтрокуРасшифровкиПлатежаПоКредитамИЗаймам(РасшифровкаПлатежа, Перечисления.ТипыСуммГрафикаКредитовИЗаймов.ОсновнойДолг, СуммаОсновногоДолга);
			
		КонецЦикла;
		
		Если ОстатокСуммыКРаспределению > 0 Тогда
			ЗаполнитьСтрокуРасшифровкиПлатежаПоКредитамИЗаймам(РасшифровкаПлатежа, Неопределено, ОстатокСуммыКРаспределению);
		КонецЕсли;
		
	КонецЕсли;
	
	АдресРасшифровкиПлатежаВХранилище = ПоместитьВоВременноеХранилище(РасшифровкаПлатежа, УникальныйИдентификатор);
	
КонецПроцедуры

// Процедура добавляет и заполняет одну строку таблицы значений, которая будет передана в форму документа.
//
&НаСервере
Процедура ЗаполнитьСтрокуРасшифровкиПлатежаПоКредитамИЗаймам(РасшифровкаПлатежа, ТипСуммы, Сумма)

	Если Сумма > 0 Тогда
		НоваяСтрока = РасшифровкаПлатежа.Добавить();
		НоваяСтрока.ТипСуммы = ТипСуммы;
		НоваяСтрока.СуммаРасчетов = Сумма;
		НоваяСтрока.Курс = КурсРасчетов;
		НоваяСтрока.Кратность = КратностьРасчетов;
		НоваяСтрока.СуммаПлатежа = Сумма * КурсРасчетов * КратностьПлатежа / (КратностьРасчетов * КурсПлатежа);
		НоваяСтрока.СтавкаНДС = СтавкаНДСПоУмолчанию;
		СтавкаНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(НоваяСтрока.СтавкаНДС);
		НоваяСтрока.СуммаНДС = НоваяСтрока.СуммаПлатежа - (НоваяСтрока.СуммаПлатежа) / ((СтавкаНДС + 100) / 100);
	КонецЕсли;

КонецПроцедуры

// Процедура заполняет таблицу ДанныеПлатежа.
//
&НаСервере
Процедура ЗаполнитьИнформациюПоКредитуЗаймуНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ГрафикПогашенияКредитовИЗаймовСрезПоследних.Период КАК Период,
		|	ГрафикПогашенияКредитовИЗаймовСрезПоследних.СуммаОсновногоДолга КАК СуммаОсновногоДолга,
		|	ГрафикПогашенияКредитовИЗаймовСрезПоследних.СуммаПроцентов КАК СуммаПроцентов,
		|	ГрафикПогашенияКредитовИЗаймовСрезПоследних.СуммаКомиссии КАК СуммаКомиссии
		|ИЗ
		|	РегистрСведений.ГрафикПогашенияКредитовИЗаймов.СрезПоследних(&ДатаСрезаПоследних, ДоговорКредитаЗайма = &ДоговорКредитаЗайма) КАК ГрафикПогашенияКредитовИЗаймовСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СУММА(РасчетыПоКредитамИЗаймамОстатки.ОсновнойДолгВалОстаток) КАК ОсновнойДолгВалОстаток,
		|	РасчетыПоКредитамИЗаймамОстатки.ДоговорКредитаЗайма.ВалютаРасчетов КАК ДоговорКредитаЗаймаВалютаРасчетов,
		|	СУММА(РасчетыПоКредитамИЗаймамОстатки.ПроцентыВалОстаток) КАК ПроцентыВалОстаток,
		|	СУММА(РасчетыПоКредитамИЗаймамОстатки.КомиссияВалОстаток) КАК КомиссияВалОстаток
		|ПОМЕСТИТЬ ВременнаяТаблицаОстатки
		|ИЗ
		|	РегистрНакопления.РасчетыПоКредитамИЗаймам.Остатки(, ДоговорКредитаЗайма = &ДоговорКредитаЗайма) КАК РасчетыПоКредитамИЗаймамОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	РасчетыПоКредитамИЗаймамОстатки.ДоговорКредитаЗайма.ВалютаРасчетов
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА РасчетыПоКредитамИЗаймам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА -РасчетыПоКредитамИЗаймам.ОсновнойДолгВал
		|		ИНАЧЕ РасчетыПоКредитамИЗаймам.ОсновнойДолгВал
		|	КОНЕЦ,
		|	РасчетыПоКредитамИЗаймам.ДоговорКредитаЗайма.ВалютаРасчетов,
		|	ВЫБОР
		|		КОГДА РасчетыПоКредитамИЗаймам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА -РасчетыПоКредитамИЗаймам.ПроцентыВал
		|		ИНАЧЕ РасчетыПоКредитамИЗаймам.ПроцентыВал
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА РасчетыПоКредитамИЗаймам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА -РасчетыПоКредитамИЗаймам.КомиссияВал
		|		ИНАЧЕ РасчетыПоКредитамИЗаймам.КомиссияВал
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.РасчетыПоКредитамИЗаймам КАК РасчетыПоКредитамИЗаймам
		|ГДЕ
		|	РасчетыПоКредитамИЗаймам.ДоговорКредитаЗайма = &ДоговорКредитаЗайма
		|	И РасчетыПоКредитамИЗаймам.Регистратор = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	РасчетыПоКредитамИЗаймам.ДоговорКредитаЗайма.ВалютаРасчетов,
		|	ВЫБОР
		|		КОГДА РасчетыПоКредитамИЗаймам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА -РасчетыПоКредитамИЗаймам.ОсновнойДолгВал
		|		ИНАЧЕ РасчетыПоКредитамИЗаймам.ОсновнойДолгВал
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА РасчетыПоКредитамИЗаймам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА -РасчетыПоКредитамИЗаймам.ПроцентыВал
		|		ИНАЧЕ РасчетыПоКредитамИЗаймам.ПроцентыВал
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА РасчетыПоКредитамИЗаймам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА -РасчетыПоКредитамИЗаймам.КомиссияВал
		|		ИНАЧЕ РасчетыПоКредитамИЗаймам.КомиссияВал
		|	КОНЕЦ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ГрафикПогашенияКредитовИЗаймовСрезПервых.Период КАК Период,
		|	ГрафикПогашенияКредитовИЗаймовСрезПервых.СуммаОсновногоДолга КАК СуммаОсновногоДолга,
		|	ГрафикПогашенияКредитовИЗаймовСрезПервых.СуммаПроцентов КАК СуммаПроцентов,
		|	ГрафикПогашенияКредитовИЗаймовСрезПервых.СуммаКомиссии КАК СуммаКомиссии
		|ИЗ
		|	РегистрСведений.ГрафикПогашенияКредитовИЗаймов.СрезПервых(&ДатаСрезаПоследних, ДоговорКредитаЗайма = &ДоговорКредитаЗайма) КАК ГрафикПогашенияКредитовИЗаймовСрезПервых
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СУММА(ЕСТЬNULL(ГрафикПогашенияКредитовИЗаймов.СуммаОсновногоДолга, 0)) КАК СуммаОсновногоДолга,
		|	СУММА(ЕСТЬNULL(ГрафикПогашенияКредитовИЗаймов.СуммаПроцентов, 0)) КАК СуммаПроцентов,
		|	СУММА(ЕСТЬNULL(ГрафикПогашенияКредитовИЗаймов.СуммаКомиссии, 0)) КАК СуммаКомиссии
		|ИЗ
		|	РегистрСведений.ГрафикПогашенияКредитовИЗаймов КАК ГрафикПогашенияКредитовИЗаймов
		|ГДЕ
		|	ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма = &ДоговорКредитаЗайма
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СУММА(ВЫБОР
		|			КОГДА РасчетыПоКредитамИЗаймамОбороты.ВидДоговора = &ВидДоговораДоговорКредита
		|				ТОГДА РасчетыПоКредитамИЗаймамОбороты.ОсновнойДолгВалРасход
		|			ИНАЧЕ РасчетыПоКредитамИЗаймамОбороты.ОсновнойДолгВалПриход
		|		КОНЕЦ) КАК ОсновнойДолгВалПолучено,
		|	СУММА(ВЫБОР
		|			КОГДА РасчетыПоКредитамИЗаймамОбороты.ВидДоговора = &ВидДоговораДоговорКредита
		|				ТОГДА РасчетыПоКредитамИЗаймамОбороты.ПроцентыВалПриход
		|			ИНАЧЕ РасчетыПоКредитамИЗаймамОбороты.ПроцентыВалРасход
		|		КОНЕЦ) КАК ПроцентыВалОплачено,
		|	СУММА(ВЫБОР
		|			КОГДА РасчетыПоКредитамИЗаймамОбороты.ВидДоговора = &ВидДоговораДоговорКредита
		|				ТОГДА РасчетыПоКредитамИЗаймамОбороты.КомиссияВалПриход
		|			ИНАЧЕ РасчетыПоКредитамИЗаймамОбороты.КомиссияВалРасход
		|		КОНЕЦ) КАК КомиссияВалОплачено,
		|	СУММА(ВЫБОР
		|			КОГДА РасчетыПоКредитамИЗаймамОбороты.ВидДоговора = &ВидДоговораДоговорКредита
		|				ТОГДА РасчетыПоКредитамИЗаймамОбороты.ОсновнойДолгВалПриход
		|			ИНАЧЕ РасчетыПоКредитамИЗаймамОбороты.ОсновнойДолгВалРасход
		|		КОНЕЦ) КАК ОсновнойДолгВалОплачено
		|ИЗ
		|	РегистрНакопления.РасчетыПоКредитамИЗаймам.Обороты(, , Регистратор, ДоговорКредитаЗайма = &ДоговорКредитаЗайма) КАК РасчетыПоКредитамИЗаймамОбороты
		|ГДЕ
		|	РасчетыПоКредитамИЗаймамОбороты.Регистратор <> &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СУММА(ЕСТЬNULL(ВременнаяТаблицаОстатки.ОсновнойДолгВалОстаток, 0)) КАК ОсновнойДолгВалОстаток,
		|	ВременнаяТаблицаОстатки.ДоговорКредитаЗаймаВалютаРасчетов КАК ДоговорКредитаЗаймаВалютаРасчетов,
		|	СУММА(ЕСТЬNULL(ВременнаяТаблицаОстатки.ПроцентыВалОстаток, 0)) КАК ПроцентыВалОстаток,
		|	СУММА(ЕСТЬNULL(ВременнаяТаблицаОстатки.КомиссияВалОстаток, 0)) КАК КомиссияВалОстаток
		|ИЗ
		|	ВременнаяТаблицаОстатки КАК ВременнаяТаблицаОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаОстатки.ДоговорКредитаЗаймаВалютаРасчетов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КурсыВалютСрезПоследних.Курс КАК Курс,
		|	КурсыВалютСрезПоследних.Кратность КАК Кратность
		|ИЗ
		|	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &ВалютаРасчетов) КАК КурсыВалютСрезПоследних";
	
	Запрос.УстановитьПараметр("ДатаСрезаПоследних", ?(Дата = '00010101', НачалоДня(ТекущаяДата()), НачалоДня(Дата)));
	Запрос.УстановитьПараметр("ДоговорКредитаЗайма", ДоговорКредитаЗайма);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидДоговораДоговорКредита", Перечисления.ВидыДоговоровКредитаИЗайма.КредитПолученный);
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Ссылка.Дата), Ссылка.Дата, ТекущаяДата()));
	Запрос.УстановитьПараметр("ВалютаРасчетов", ДоговорКредитаЗайма.ВалютаРасчетов);
	
	МРезультатов = Запрос.ВыполнитьПакет();
	
	// Курс и кратность
	ВыборкаКурсИКратность = МРезультатов[6].Выбрать();
	Если ВыборкаКурсИКратность.Следующий() Тогда
		КурсРасчетов = ВыборкаКурсИКратность.Курс;
		КратностьРасчетов = ВыборкаКурсИКратность.Кратность;
	Иначе
		КурсРасчетов = 1;
		КратностьРасчетов = 1;
	КонецЕсли;
	// Конец Курс и кратность
	
	Если ДоговорКредитаЗайма.ВидДоговора = Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику Тогда
		Множитель = 1;
	Иначе
		Множитель = -1;
	КонецЕсли;
	
	ИнфомрацияПоКредитуЗайму = "";
	
	ВыборкаГрафик = МРезультатов[0].Выбрать();
	ВыборкаГрафикБудущиеМесяцы = МРезультатов[2].Выбрать();
	
	Флаг1 = Ложь;
	Флаг2 = Ложь;
	Флаг3 = Ложь;
	Флаг4 = Ложь;
	
	// Следующий платеж.
	Если ВыборкаГрафикБудущиеМесяцы.Следующий() Тогда
		
		ДатаПлатежа = "" + Формат(ВыборкаГрафикБудущиеМесяцы.Период, "ДФ=dd.MM.yyyy");
			
		НоваяСтрока = ДанныеПлатежа.Добавить();
		НоваяСтрока.ДатаПлатежа = ВыборкаГрафикБудущиеМесяцы.Период;
		НоваяСтрока.СуммаОсновногоДолга = ВыборкаГрафикБудущиеМесяцы.СуммаОсновногоДолга;
		НоваяСтрока.СуммаПроцентов = ВыборкаГрафикБудущиеМесяцы.СуммаПроцентов;
		НоваяСтрока.СуммаКомиссии = ВыборкаГрафикБудущиеМесяцы.СуммаКомиссии;
		НоваяСтрока.Описание = "Очередной платеж";
		НоваяСтрока.Отметка = Истина;
		
		Флаг1 = Истина;
			
	Иначе
		НоваяСтрока = ДанныеПлатежа.Добавить();
		НоваяСтрока.Описание = "Очередной платеж";
	КонецЕсли;
		
	// Предыдущий платеж.
	Если ВыборкаГрафик.Следующий() Тогда
		
		ДатаПлатежа = "" + Формат(ВыборкаГрафик.Период, "ДФ=dd.MM.yyyy");
			
		НоваяСтрока = ДанныеПлатежа.Добавить();
		НоваяСтрока.ДатаПлатежа = ВыборкаГрафик.Период;
		НоваяСтрока.СуммаОсновногоДолга = ВыборкаГрафик.СуммаОсновногоДолга;
		НоваяСтрока.СуммаПроцентов = ВыборкаГрафик.СуммаПроцентов;
		НоваяСтрока.СуммаКомиссии = ВыборкаГрафик.СуммаКомиссии;
		НоваяСтрока.Описание = "Предыдущий платеж";
		НоваяСтрока.Отметка = Не Флаг1;
		Флаг2 = НоваяСтрока.Отметка;
		
	Иначе
		НоваяСтрока = ДанныеПлатежа.Добавить();
		НоваяСтрока.Описание = "Предыдущий платеж";
	КонецЕсли;
	
	// Остатки.
	ВыборкаОстатки = МРезультатов[5].Выбрать();
	Если ВыборкаОстатки.Следующий() Тогда
		
		НоваяСтрока = ДанныеПлатежа.Добавить();
		НоваяСтрока.ДатаПлатежа = Дата;
		НоваяСтрока.СуммаОсновногоДолга = Множитель * ВыборкаОстатки.ОсновнойДолгВалОстаток;
		НоваяСтрока.СуммаПроцентов = Множитель * ВыборкаОстатки.ПроцентыВалОстаток;
		НоваяСтрока.СуммаКомиссии = Множитель * ВыборкаОстатки.КомиссияВалОстаток;
		НоваяСтрока.Описание = "Остаток долга";
		НоваяСтрока.Отметка = (Не Флаг1 И Не Флаг2);
		Флаг3 = НоваяСтрока.Отметка;
		
	Иначе
		НоваяСтрока = ДанныеПлатежа.Добавить();
		НоваяСтрока.Описание = "Остаток долга";
	КонецЕсли;
	
	// Под расчет.
	ВыборкаВсегоГрафик = МРезультатов[3].Выбрать();
	ВыборкаВсегоГрафик.Следующий();
	ВыборкаВсегоОбороты = МРезультатов[4].Выбрать();
	ВыборкаВсегоОбороты.Следующий();
	
	ОсновнойДолгВалПолучено = ?(ЗначениеЗаполнено(ВыборкаВсегоОбороты.ОсновнойДолгВалПолучено), ВыборкаВсегоОбороты.ОсновнойДолгВалПолучено, 0);
	ОсновнойДолгВалОплачено = ?(ЗначениеЗаполнено(ВыборкаВсегоОбороты.ОсновнойДолгВалОплачено), ВыборкаВсегоОбороты.ОсновнойДолгВалОплачено, 0);
	ПроцентыВалОплачено = ?(ЗначениеЗаполнено(ВыборкаВсегоОбороты.ПроцентыВалОплачено), ВыборкаВсегоОбороты.ПроцентыВалОплачено, 0);
	КомиссияВалОплачено = ?(ЗначениеЗаполнено(ВыборкаВсегоОбороты.КомиссияВалОплачено), ВыборкаВсегоОбороты.КомиссияВалОплачено, 0);
	
	ВсегоПолучено = ОсновнойДолгВалПолучено;
	ВсегоОсновнойДолг = Макс(0, ВсегоПолучено - ОсновнойДолгВалОплачено);
	
	ВсегоПроценты = Макс(0, ?(ВыборкаВсегоГрафик.СуммаПроцентов = Null, 0,ВыборкаВсегоГрафик.СуммаПроцентов) - ПроцентыВалОплачено);
	ВсегоКомиссия = Макс(0, ?(ВыборкаВсегоГрафик.СуммаКомиссии = Null, 0,ВыборкаВсегоГрафик.СуммаКомиссии) - КомиссияВалОплачено);
	
	Если ВсегоОсновнойДолг > 0 Или ВсегоПроценты > 0 Или ВсегоКомиссия > 0 Тогда
		
		НоваяСтрока = ДанныеПлатежа.Добавить();
		НоваяСтрока.ДатаПлатежа = Дата;
		НоваяСтрока.СуммаОсновногоДолга = ВсегоОсновнойДолг;
		НоваяСтрока.СуммаПроцентов = ВсегоПроценты;
		НоваяСтрока.СуммаКомиссии = ВсегоКомиссия;
		НоваяСтрока.Описание = "Под расчет";
		НоваяСтрока.Отметка = (Не Флаг1 И Не Флаг2 И Не Флаг3);
		
	Иначе
		НоваяСтрока = ДанныеПлатежа.Добавить();
		НоваяСтрока.Описание = "Под расчет";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
