#Область ОписаниеПеременных

&НаКлиенте
Перем НомерТекущейСтроиЗаписиОСтаже;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗаписиОСтажеТекст = НСтр("ru = 'Записи о стаже'");
	
	ОтчетныйПериодСтрока = УчетСтраховыхВзносов.ПредставлениеОтчетногоПериода(Объект.ОтчетныйПериод);
	ПриПолученииДанныхНаСервере(Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "РедактированиеДанныхСЗВ6ПоСотруднику" Тогда
		ПриИзмененииДанныхДокументаПоСотруднику(Параметр.АдресВоВременномХранилище);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ДанныеФормыВОбъект(ТекущийОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СотрудникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	ПерсонифицированныйУчетКлиентСервер.ДокументыРедактированияСтажаСотрудникиПередУдалением(Элементы.Сотрудники.ВыделенныеСтроки, Объект.Сотрудники, Объект.ЗаписиОСтаже);	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не ТолькоПросмотр И Поле.Имя = "СотрудникиФизическоеЛицо" Тогда
		ТекущиеДанныеСтроки = Элементы.Сотрудники.ТекущиеДанные;
		Если ТекущиеДанныеСтроки <> Неопределено Тогда
			ПоказатьЗначение(,ТекущиеДанныеСтроки.Сотрудник);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы


&НаКлиенте
Процедура СотрудникиПриАктивизацииСтроки(Элемент)
		ДокументыСЗВСотрудникиПриАктивацииСтроки(Элементы.Сотрудники, ТекущийСотрудник, Элементы.ЗаписиОСтаже);
	УстановитьПредставлениеМесяцевЗаработкаСЗВ64(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Записать(Новый Структура("РежимЗаписи ",РежимЗаписиДокумента.Проведение)) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	ОбъектВДанныеФормы(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбъектВДанныеФормы(ТекущийОбъект)
	СтрокиПоСотрудникам = Новый Соответствие;
	
	НачальныйМесяц = Месяц(Объект.ОтчетныйПериод);
	
	Для Каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
		СтрокаСотрудник.СведенияОЗаработке.Очистить();
		
		СтрокиПоСотрудникам.Вставить(СтрокаСотрудник.Сотрудник, СтрокаСотрудник);	
		
		Для НомерМесяца = 0 По 2 Цикл
			СтрокаЗаработок = СтрокаСотрудник.СведенияОЗаработке.Вставить(НомерМесяца);
			СтрокаЗаработок.Месяц =НачальныйМесяц + НомерМесяца;
		КонецЦикла;	
	КонецЦикла;	
	
	Для Каждого СтрокаЗаработок Из Объект.СведенияОЗаработке Цикл
		Если СтрокаЗаработок.Месяц > 0 Тогда
		
			СтрокаПоСотруднику = СтрокиПоСотрудникам[СтрокаЗаработок.Сотрудник];	
			Если СтрокаПоСотруднику <> Неопределено Тогда
				СтрокаЗаработокПоСотруднику = СтрокаПоСотруднику.СведенияОЗаработке[СтрокаЗаработок.Месяц - НачальныйМесяц];
				ЗаполнитьЗначенияСвойств(СтрокаЗаработокПоСотруднику, СтрокаЗаработок);
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Процедура ДанныеФормыВОбъект(ТекущийОбъект)
	ТекущийОбъект.СведенияОЗаработке.Очистить();
	
	Для Каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
		Для Каждого СтрокаЗаработокПоСотруднику Из СтрокаСотрудник.СведенияОЗаработке Цикл
			Если СтрокаСведенийОЗаработкеЗаполнена(СтрокаЗаработокПоСотруднику) Тогда
				СтрокаЗаработок = ТекущийОбъект.СведенияОЗаработке.Добавить();	
				ЗаполнитьЗначенияСвойств(СтрокаЗаработок, СтрокаЗаработокПоСотруднику);
				СтрокаЗаработок.Сотрудник = СтрокаСотрудник.Сотрудник;
			КонецЕсли;	
		КонецЦикла;	
	КонецЦикла;	
КонецПроцедуры	

&НаСервере 
Функция СтрокаСведенийОЗаработкеЗаполнена(СтрокаЗаработок)
	Если СтрокаЗаработок.Заработок <> 0
		Или СтрокаЗаработок.ОблагаетсяВзносамиДоПредельнойВеличины <> 0
		Или СтрокаЗаработок.ОблагаетсяВзносамиСвышеПредельнойВеличины <> 0 Тогда
		
		Возврат Истина;
	КонецЕсли;	

	Возврат Ложь;
КонецФункции


&НаСервере
Функция ОписаниеЭлементовСИндикациейОшибок() Экспорт
	ОписаниеЭлементовИндикацииОшибок = Новый Соответствие;	
	Возврат ОписаниеЭлементовИндикацииОшибок;
КонецФункции	

&НаКлиенте
Процедура ПриИзмененииДанныхДокументаПоСотруднику(АдресВоВременномХранилище)
	ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище);
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище)
	
	ДанныеШапкиДокумента = Объект;
	
	ДанныеТекущегоДокумента = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Если ДанныеТекущегоДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Неопределено;
	НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(Новый Структура("ИсходныйНомерСтроки", ДанныеТекущегоДокумента.ИсходныйНомерСтроки));
		
	Если НайденныеСтроки.Количество() > 0 Тогда
		ДанныеТекущейСтрокиПоСотруднику = НайденныеСтроки[0];
		
		Если ДанныеТекущейСтрокиПоСотруднику.Сотрудник <> ДанныеТекущегоДокумента.Сотрудник Тогда
			ДанныеТекущейСтрокиПоСотруднику = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено  Тогда
		
		ВызватьИсключение НСтр("ru = 'В текущем документе не найдены данные по редактируемому сотруднику.'");
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
		
	ЗаполнитьЗначенияСвойств(ДанныеТекущейСтрокиПоСотруднику, ДанныеТекущегоДокумента);
		
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	
	СтрокиЗаработка = Объект.СведенияОЗаработке.НайтиСтроки(СтруктураПоиска);
	
	СуществущиеСтрокиЗаработка = Новый Массив;
	
	ДанныеТекущейСтрокиПоСотруднику.Заработок = 0;
	ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиДоПредельнойВеличины = 0;
	ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиСвышеПредельнойВеличины = 0;
	ДанныеТекущейСтрокиПоСотруднику.ПоДоговорамГПХДоПредельнойВеличины = 0;
	
	Для Каждого СтрокаЗаработок Из ДанныеТекущегоДокумента.СведенияОЗаработке Цикл
		СтрокаЗаработокОбъекта = Объект.СведенияОЗаработке.НайтиПоИдентификатору(СтрокаЗаработок.ИдентификаторИсходнойСтроки);
		
		Если СтрокаЗаработокОбъекта = Неопределено Тогда
			СтрокаЗаработокОбъекта = Объект.СведенияОЗаработке.Добавить();
			СтрокаЗаработокОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
		Иначе
			СуществущиеСтрокиЗаработка.Добавить(СтрокаЗаработокОбъекта.ПолучитьИдентификатор());
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаЗаработокОбъекта, СтрокаЗаработок);
		
		Если СтрокаЗаработокОбъекта.Месяц <> 0 Тогда
			ДанныеТекущейСтрокиПоСотруднику.Заработок = ДанныеТекущейСтрокиПоСотруднику.Заработок + СтрокаЗаработок.Заработок;
			ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиДоПредельнойВеличины = ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиДоПредельнойВеличины + СтрокаЗаработок.ОблагаетсяВзносамиДоПредельнойВеличины;
			ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиСвышеПредельнойВеличины = ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиСвышеПредельнойВеличины + СтрокаЗаработок.ОблагаетсяВзносамиСвышеПредельнойВеличины;
			ДанныеТекущейСтрокиПоСотруднику.ПоДоговорамГПХДоПредельнойВеличины = ДанныеТекущейСтрокиПоСотруднику.ПоДоговорамГПХДоПредельнойВеличины + СтрокаЗаработок.ПоДоговорамГПХДоПредельнойВеличины;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаЗаработокСотрудника Из СтрокиЗаработка Цикл
		Если СуществущиеСтрокиЗаработка.Найти(СтрокаЗаработокСотрудника.ПолучитьИдентификатор()) = Неопределено Тогда
			Объект.СведенияОЗаработке.Удалить(Объект.СведенияОЗаработке.Индекс(СтрокаЗаработокСотрудника));
		КонецЕсли;
	КонецЦикла;
	
	СтрокиСтажа = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	
	СуществущиеСтрокиСтажа = Новый Массив;
	
	СтрокиСтажаПоСотруднику = Новый Массив;
	Для Каждого СтрокаСтаж Из ДанныеТекущегоДокумента.ЗаписиОСтаже Цикл
		СтрокаСтажОбъекта = Объект.ЗаписиОСтаже.НайтиПоИдентификатору(СтрокаСтаж.ИдентификаторИсходнойСтроки);
		
		Если СтрокаСтажОбъекта = Неопределено Тогда
			СтрокаСтажОбъекта = Объект.ЗаписиОСтаже.Добавить();
			СтрокаСтажОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
		Иначе
			СуществущиеСтрокиСтажа.Добавить(СтрокаСтажОбъекта.ПолучитьИдентификатор());
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаСтажОбъекта, СтрокаСтаж);
		
		СтрокиСтажаПоСотруднику.Добавить(СтрокаСтажОбъекта);
	КонецЦикла;
	
	ПерсонифицированныйУчетКлиентСервер.ВыполнитьНумерациюЗаписейОСтаже(СтрокиСтажаПоСотруднику);
	
	Для Каждого СтрокаСтажСотрудника Из СтрокиСтажа Цикл
		Если СуществущиеСтрокиСтажа.Найти(СтрокаСтажСотрудника.ПолучитьИдентификатор()) = Неопределено Тогда
			Объект.ЗаписиОСтаже.Удалить(Объект.ЗаписиОСтаже.Индекс(СтрокаСтажСотрудника));
		КонецЕсли;
	КонецЦикла;
	
	СтрокиВредногоЗаработка = Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.НайтиСтроки(СтруктураПоиска);
	
	СуществущиеСтрокиВредногоЗаработка = Новый Массив;
	
	СтрокиВредногоЗаработкаПоСотруднику = Новый Массив;
	Для Каждого СтрокаВредныйЗаработок Из ДанныеТекущегоДокумента.СведенияОЗаработкеНаВредныхИТяжелыхРаботах Цикл
		СтрокаВредныйЗаработокОбъекта = Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.НайтиПоИдентификатору(СтрокаВредныйЗаработок.ИдентификаторИсходнойСтроки);
		
		Если СтрокаВредныйЗаработокОбъекта = Неопределено Тогда
			СтрокаВредныйЗаработокОбъекта = Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Добавить();
			СтрокаВредныйЗаработокОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
		Иначе
			СуществущиеСтрокиВредногоЗаработка.Добавить(СтрокаВредныйЗаработокОбъекта.ПолучитьИдентификатор());
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаВредныйЗаработокОбъекта, СтрокаВредныйЗаработок);
		
	КонецЦикла;
			
	Для Каждого СтрокаВредныйЗаработокСотрудника Из СтрокиВредногоЗаработка Цикл
		Если СуществущиеСтрокиВредногоЗаработка.Найти(СтрокаВредныйЗаработокСотрудника.ПолучитьИдентификатор()) = Неопределено Тогда
			Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Удалить(Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Индекс(СтрокаВредныйЗаработокСотрудника));
		КонецЕсли;
	КонецЦикла;

	Если ДанныеТекущегоДокумента.Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьРаздел6РасчетаРСВ_1(Команда)
	
	Если Модифицированность И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Объект.Ссылка);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ПачкаРазделов6РасчетаРСВ_1", "ФормаРаздел6", МассивОбъектов, ЭтаФорма, Новый Структура());
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДокументыСЗВСотрудникиПриАктивацииСтроки(ЭлементФормыСотрудники, ТекущийСотрудник, ЭлементФормыЗаписиОСтаже = Неопределено) 
	
	ТекущиеДанныеСтроки =  ЭлементФормыСотрудники.ТекущиеДанные;
	
	Если ТекущиеДанныеСтроки <> Неопределено Тогда
		ТекущийСотрудник = ТекущиеДанныеСтроки.Сотрудник;
		Если ЭлементФормыЗаписиОСтаже <> Неопределено Тогда
			СтруктураОтбора = Новый ФиксированнаяСтруктура("Сотрудник", ТекущиеДанныеСтроки.Сотрудник);
			ЭлементФормыЗаписиОСтаже.ОтборСтрок = СтруктураОтбора;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеМесяцевЗаработкаСЗВ64(Форма)
	
	Если Форма.Объект.ТипСведенийСЗВ = ПредопределенноеЗначение("Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ") Тогда
		ПериодДокумента = Форма.Объект.ОтчетныйПериод;
	Иначе
		ПериодДокумента = Форма.Объект.КорректируемыйПериод;
	КонецЕсли;
	
	Если Форма.Элементы.Сотрудники.ТекущаяСтрока <> Неопределено Тогда 
		ДанныеТекущейСтрокиСотрудник = Форма.Объект.Сотрудники.НайтиПоИдентификатору(Форма.Элементы.Сотрудники.ТекущаяСтрока);
	КонецЕсли;	
	
	Если ДанныеТекущейСтрокиСотрудник <> Неопределено Тогда
		Для Каждого СтрокаЗаработок Из ДанныеТекущейСтрокиСотрудник.СведенияОЗаработке Цикл
			СтрокаЗаработок.МесяцПредставление = Формат(Дата(2014, СтрокаЗаработок.Месяц , 1), "ДФ=ММММ");	
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры	


#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти





#КонецОбласти
