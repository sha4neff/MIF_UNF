#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийФормы

Процедура ПриСозданииПриЧтенииНаСервере(Форма, Объект, ЭтоФормаРедактированияТегов = Ложь) Экспорт
	
	ЗаполнитьНастройкиТегов(Форма, ЭтоФормаРедактированияТегов);
	Если ЭтоФормаРедактированияТегов Тогда
		ПрочитатьДанныеОбщихТегов(Форма, Объект);
	Иначе
		ПрочитатьДанныеТегов(Форма, Объект);
	КонецЕсли;
	ОбновитьЭлементыТегов(Форма);
	
КонецПроцедуры

Процедура ПередЗаписьюНаСервере(Форма,ТекущийОбъект) Экспорт
	
	ЗаписатьДанныеТегов(Форма, ТекущийОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

Процедура ПолеВводаТегаОкончаниеВводаТекста(Форма, Текст, СтандартнаяОбработка) Экспорт
	
	Если Не ПустаяСтрока(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		СоздатьИПрикрепитьТегНаСервере(Форма,Текст);
		ТекущийЭлемент = Форма.Элементы.ПолеВводаТега;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеВводаТегаОбработкаВыбора(Форма, ИмяЭлемента, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = ТипЗнч(ПустаяСсылкаТега(Форма)) Тогда
		ПрикрепитьТегНаСервере(Форма, ВыбранноеЗначение);
	КонецЕсли;
	Форма.Элементы[ИмяЭлемента].ОбновитьТекстРедактирования();
	
КонецПроцедуры

Процедура ОблакоТеговОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ЭтоФормаРедактированияТегов = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ТегИД = Сред(НавигационнаяСсылкаФорматированнойСтроки, СтрДлина("Тег_")+1);
	СтрокаТегов = Форма.ДанныеТегов.НайтиПоИдентификатору(ТегИД);
	
	Если ЭтоФормаРедактированияТегов Тогда
		УдаляемыйТег = Форма.УдаляемыеТеги.Добавить();
		УдаляемыйТег.Тег = СтрокаТегов.Тег;
	КонецЕсли;
	
	Форма.ДанныеТегов.Удалить(СтрокаТегов);
	
	ОбновитьЭлементыТегов(Форма);
	
	Модифицированность = Истина;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаполнитьНастройкиТегов(Форма, ЭтоФормаРедактированияТегов)
	
	МетаданныеТегов = ОпределитьМетаданныеТегов(Форма, ЭтоФормаРедактированияТегов);
	
	Форма.НастройкиТегов = Новый Структура;
	Форма.НастройкиТегов.Вставить("МенеджерТегов", МетаданныеТегов.ПолноеИмя());
	
КонецФункции

Функция ОпределитьМетаданныеТегов(Форма, ЭтоФормаРедактированияТегов)
	
	Если ЭтоФормаРедактированияТегов Тогда
		МетаданныеВыбранныхОбъектов = Форма.ВыделенныеОбъекты[0].Объект.Метаданные();
		ТипТегов = МетаданныеВыбранныхОбъектов.ТабличныеЧасти.Теги.Реквизиты.Тег.Тип.Типы()[0];
	Иначе
		ТипТегов = ТипЗнч(Форма.ПолеВводаТега);
	КонецЕсли;
	
	Возврат Метаданные.НайтиПоТипу(ТипТегов);
	
КонецФункции

Функция МенеджерТегов(Форма)
	
	Возврат ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Форма.НастройкиТегов.МенеджерТегов);
	
КонецФункции

Функция ПустаяСсылкаТега(Форма)
	
	Возврат МенеджерТегов(Форма).ПустаяСсылка();
	
КонецФункции

Процедура ПрочитатьДанныеТегов(Форма, Объект)
	
	Форма.ДанныеТегов.Очистить();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаСправочникаТеги.Тег КАК Тег,
		|	ТаблицаСправочникаТеги.Тег.ПометкаУдаления КАК ПометкаУдаления,
		|	ТаблицаСправочникаТеги.Тег.Наименование КАК Наименование
		|ИЗ
		|	&ТаблицаСправочника КАК ТаблицаСправочникаТеги
		|ГДЕ
		|	ТаблицаСправочникаТеги.Ссылка = &Ссылка";
	
	МетаданныеСправочника = Объект.Ссылка.Метаданные();
	Запрос.Текст = СтрЗаменить(Запрос.Текст , "&ТаблицаСправочника", МетаданныеСправочника.ПолноеИмя() + ".Теги");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НовыеДанныеТега = Форма.ДанныеТегов.Добавить();
		НавигационнаяСсылкаФС = "Тег_" + НовыеДанныеТега.ПолучитьИдентификатор();
		
		НовыеДанныеТега.Тег = Выборка.Тег;
		НовыеДанныеТега.ПометкаУдаления = Выборка.ПометкаУдаления;
		НовыеДанныеТега.ПредставлениеТега = ФорматированнаяСтрокаПредставленияТега(Выборка.Наименование, Выборка.ПометкаУдаления, НавигационнаяСсылкаФС);
		НовыеДанныеТега.ДлинаТега = СтрДлина(Выборка.Наименование);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьЭлементыТегов(Форма)
	
	ФС = Форма.ДанныеТегов.Выгрузить(, "ПредставлениеТега").ВыгрузитьКолонку("ПредставлениеТега");
	
	Индекс = ФС.Количество()-1;
	Пока Индекс > 0 Цикл
		ФС.Вставить(Индекс, "  ");
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Форма.Элементы.ОблакоТегов.Заголовок	= Новый ФорматированнаяСтрока(ФС);
	Форма.Элементы.ОблакоТегов.Видимость	= ФС.Количество() > 0;
	
КонецПроцедуры

Процедура ЗаписатьДанныеТегов(Форма, ТекущийОбъект)
	
	ТекущийОбъект.Теги.Загрузить(Форма.ДанныеТегов.Выгрузить(,"Тег"));
	
КонецПроцедуры

Процедура ПрикрепитьТегНаСервере(Форма, Тег) 
		
	Если Форма.ДанныеТегов.НайтиСтроки(Новый Структура("Тег", Тег)).Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТега = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Тег, "Наименование, ПометкаУдаления");
	
	СтрокаТегов = Форма.ДанныеТегов.Добавить();
	НавигационнаяСсылкаФС = "Тег_" + СтрокаТегов.ПолучитьИдентификатор();
	
	СтрокаТегов.Тег = Тег;
	СтрокаТегов.ПометкаУдаления = ДанныеТега.ПометкаУдаления;
	СтрокаТегов.ПредставлениеТега = ФорматированнаяСтрокаПредставленияТега(ДанныеТега.Наименование, ДанныеТега.ПометкаУдаления, НавигационнаяСсылкаФС);
	СтрокаТегов.ДлинаТега = СтрДлина(ДанныеТега.Наименование);
	
	ОбновитьЭлементыТегов(Форма);
	
	Модифицированность = Истина;
	
КонецПроцедуры

Процедура СоздатьИПрикрепитьТегНаСервере(Форма, знач ЗаголовокТега) 
	
	Тег = НайтиСоздатьТег(Форма, ЗаголовокТега);
	ПрикрепитьТегНаСервере(Форма, Тег);
	
КонецПроцедуры

Функция НайтиСоздатьТег(Форма, Знач ЗаголовокТега)
	
	МенеджерТегов = МенеджерТегов(Форма);
	Тег = МенеджерТегов.НайтиПоНаименованию(ЗаголовокТега, Истина);
	
	Если Тег.Пустая() Тогда
		
		ТегОбъект = МенеджерТегов.СоздатьЭлемент();
		ТегОбъект.Наименование = ЗаголовокТега;
		ТегОбъект.Записать();
		Тег = ТегОбъект.Ссылка;
		
	КонецЕсли;
	
	Возврат Тег;
	
КонецФункции

Функция ФорматированнаяСтрокаПредставленияТега(НаименованиеТега, ПометкаУдаления, НавигационнаяСсылкаФС)
	
	Цвет = ЦветаСтиля.ТекстВторостепеннойНадписи;
	БазовыйШрифт = ШрифтыСтиля.ОбычныйШрифтТекста;
	
	Шрифт = Новый Шрифт(БазовыйШрифт,,,Истина,,?(ПометкаУдаления, Истина, Неопределено));
	
	КомпонентыФС = Новый Массив;
	КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НаименованиеТега + Символы.НПП, Шрифт, Цвет));
	КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Очистить, , , , НавигационнаяСсылкаФС));
	
	// АПК:1356 Используется локализованное имя тега + картинка
	Возврат Новый ФорматированнаяСтрока(КомпонентыФС);
	
КонецФункции

Процедура ПрочитатьДанныеОбщихТегов(Форма,Объекты)
	
	Форма.ДанныеТегов.Очистить();
	
	Если Не ЗначениеЗаполнено(Объекты) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаСправочникаТеги.Тег КАК Тег,
		|	ТаблицаСправочникаТеги.Тег.ПометкаУдаления КАК ПометкаУдаления,
		|	ТаблицаСправочникаТеги.Тег.Наименование КАК Наименование,
		|	КОЛИЧЕСТВО(ТаблицаСправочникаТеги.Тег) КАК КоличествоТегов
		|ИЗ
		|	&ТаблицаСправочника КАК ТаблицаСправочникаТеги
		|ГДЕ
		|	ТаблицаСправочникаТеги.Ссылка В(&Ссылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаСправочникаТеги.Тег,
		|	ТаблицаСправочникаТеги.Тег.ПометкаУдаления,
		|	ТаблицаСправочникаТеги.Тег.Наименование
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(ТаблицаСправочникаТеги.Тег) = &КоличествоТегов";
	
	ИмяСправочника = Объекты[0].Ссылка.Метаданные().Имя;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст , "&ТаблицаСправочника", "Справочник." + ИмяСправочника + ".Теги");
	Запрос.УстановитьПараметр("Ссылка", Объекты);
	Запрос.УстановитьПараметр("КоличествоТегов", Объекты.Количество());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НовыеДанныеТега = Форма.ДанныеТегов.Добавить();
		НавигационнаяСсылкаФС = "Тег_" + НовыеДанныеТега.ПолучитьИдентификатор();
		
		НовыеДанныеТега.Тег = Выборка.Тег;
		НовыеДанныеТега.ПометкаУдаления = Выборка.ПометкаУдаления;
		НовыеДанныеТега.ПредставлениеТега = ФорматированнаяСтрокаПредставленияТега(Выборка.Наименование, Выборка.ПометкаУдаления, НавигационнаяСсылкаФС);
		НовыеДанныеТега.ДлинаТега = СтрДлина(Выборка.Наименование);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли