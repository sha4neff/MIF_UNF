#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруСлужебныхРеквизитовНоменклатуры(Номенклатура) Экспорт
	
	СтруктураРеквизитов = Новый Структура("Артикул, ТипНоменклатуры, ХарактеристикиИспользуются, "
										+ "ЕдиницаИзмерения, ПроверятьЗаполнениеПартий, ИспользоватьПартии, "
										+ "ПроверятьЗаполнениеХарактеристики, СтатусУказанияСерий");
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Номенклатура.Артикул КАК Артикул,
	|	Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	Номенклатура.ИспользоватьХарактеристики КАК ХарактеристикиИспользуются,
	|	Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Номенклатура.ИспользоватьПартии КАК ИспользоватьПартии,
	|	Номенклатура.ПроверятьЗаполнениеПартий КАК ПроверятьЗаполнениеПартий,
	|	Номенклатура.ПроверятьЗаполнениеХарактеристики КАК ПроверятьЗаполнениеХарактеристики
	|ПОМЕСТИТЬ РеквизитыНоменклатуры
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеквизитыНоменклатуры.Артикул КАК Артикул,
	|	РеквизитыНоменклатуры.ТипНоменклатуры КАК ТипНоменклатуры,
	|	РеквизитыНоменклатуры.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	РеквизитыНоменклатуры.ХарактеристикиИспользуются КАК ХарактеристикиИспользуются,
	|	РеквизитыНоменклатуры.ПроверятьЗаполнениеПартий КАК ПроверятьЗаполнениеПартий,
	|	РеквизитыНоменклатуры.ИспользоватьПартии КАК ИспользоватьПартии,
	|	РеквизитыНоменклатуры.ПроверятьЗаполнениеХарактеристики КАК ПроверятьЗаполнениеХарактеристики,
	|	ВЫБОР
	|		КОГДА РеквизитыНоменклатуры.ИспользоватьПартии
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтатусУказанияСерий
	|ИЗ
	|	РеквизитыНоменклатуры КАК РеквизитыНоменклатуры");
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Результат);
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

#КонецОбласти

#Область ОбработкаСобытийФорм

Процедура ЗаполнитьПродукциюВЕТИС(ТекущаяСтрока, ПараметрыЗаполнения) Экспорт
	
	Отбор = Неопределено;
	ПараметрыЗаполнения.Свойство("ОтборПродукция",Отбор);
	НоменклатураДляВыбора = Ложь;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоответствиеНоменклатурыВЕТИС.Продукция КАК Продукция,
	|	СоответствиеНоменклатурыВЕТИС.Номенклатура КАК Номенклатура
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыВЕТИС КАК СоответствиеНоменклатурыВЕТИС
	|ГДЕ
	|	СоответствиеНоменклатурыВЕТИС.Номенклатура = &Номенклатура
	|	И СоответствиеНоменклатурыВЕТИС.Характеристика = &Характеристика
	|	И (СоответствиеНоменклатурыВЕТИС.Серия = &Серия 
	|		ИЛИ &СерияЗаполнена = ЛОЖЬ)
	|	И (СоответствиеНоменклатурыВЕТИС.Продукция.Производители.Производитель = &Предприятие
	|		ИЛИ &Предприятие = ЗНАЧЕНИЕ(Справочник.ПредприятияВЕТИС.ПустаяСсылка))
	|	И (СоответствиеНоменклатурыВЕТИС.Продукция.ХозяйствующийСубъектПроизводитель = &ХозяйствующийСубъект
	|		ИЛИ &ХозяйствующийСубъект = ЗНАЧЕНИЕ(Справочник.ХозяйствующиеСубъектыВЕТИС.ПустаяСсылка))
	|	И (НЕ &ИсключатьПродукциюТретьегоУровня
	|		ИЛИ СоответствиеНоменклатурыВЕТИС.Продукция.Идентификатор <> """")
	|");
	
	Запрос.УстановитьПараметр("Номенклатура",   ТекущаяСтрока.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", ТекущаяСтрока.Характеристика);
	Запрос.УстановитьПараметр("Серия",          ТекущаяСтрока.Серия);
	Запрос.УстановитьПараметр("СерияЗаполнена", ЗначениеЗаполнено(ТекущаяСтрока.Серия));
	
	Если ЗначениеЗаполнено(Отбор) Тогда
		Если Отбор.Свойство("Предприятие") Тогда
			Запрос.УстановитьПараметр("Предприятие", Отбор.Предприятие);
		Иначе
			Запрос.УстановитьПараметр("Предприятие", Справочники.ПредприятияВЕТИС.ПустаяСсылка());
		КонецЕсли;
		Если Отбор.Свойство("ХозяйствующийСубъект") Тогда
			Запрос.УстановитьПараметр("ХозяйствующийСубъект", Отбор.ХозяйствующийСубъект);
		Иначе
			Запрос.УстановитьПараметр("ХозяйствующийСубъект", Справочники.ХозяйствующиеСубъектыВЕТИС.ПустаяСсылка());
		КонецЕсли;
	Иначе
		Запрос.УстановитьПараметр("Предприятие", Справочники.ПредприятияВЕТИС.ПустаяСсылка());
		Запрос.УстановитьПараметр("ХозяйствующийСубъект", Справочники.ХозяйствующиеСубъектыВЕТИС.ПустаяСсылка());
	КонецЕсли;
	
	Если ПараметрыЗаполнения.Свойство("ИсключатьПродукциюТретьегоУровня") Тогда
		Запрос.УстановитьПараметр("ИсключатьПродукциюТретьегоУровня", ПараметрыЗаполнения.ИсключатьПродукциюТретьегоУровня);
	Иначе
		Запрос.УстановитьПараметр("ИсключатьПродукциюТретьегоУровня", Ложь);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	КоличествоСопоставлено = Выборка.Количество();
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.НоменклатураДляВыбора) Тогда
		ТекущаяСтрока.НоменклатураДляВыбора.Очистить();
	Иначе
		ТекущаяСтрока.НоменклатураДляВыбора = Новый СписокЗначений;
	КонецЕсли;
	
	
	Пока Выборка.Следующий() Цикл
		Если КоличествоСопоставлено = 1 Тогда
			ТекущаяСтрока.Продукция = Выборка.Продукция;
		КонецЕсли;
		ТекущаяСтрока.НоменклатураДляВыбора.Добавить(Выборка.Продукция);
	КонецЦикла;
	
	Если КоличествоСопоставлено = 0 Тогда
		ТекущаяСтрока.Продукция = Неопределено;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ТогдаСопоставлениеТекст") Тогда 
		Если КоличествоСопоставлено > 1 Тогда
			ТекущаяСтрока.СопоставлениеТекст = СтрШаблон(НСтр("ru = '<Несколько позиций (%1)>'"), КоличествоСопоставлено);
		ИначеЕсли КоличествоСопоставлено = 1 Тогда
			ТекущаяСтрока.СопоставлениеТекст = "";
		Иначе
			ТекущаяСтрока.СопоставлениеТекст = НСтр("ru = '<Не сопоставлено>'");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьСериюРассчитатьСтатус(Объект, ТекущаяСтрока) Экспорт
	
	СерииИспользуются = ИнтеграцияИС.ПризнакИспользованияСерий(ТекущаяСтрока.Номенклатура);
	
	Если НЕ СерииИспользуются Тогда
		Возврат;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) И ТекущаяСтрока.Номенклатура.ИспользоватьПартии Тогда
		
		Если ЗначениеЗаполнено(ТекущаяСтрока.Серия) И ТекущаяСтрока.Серия.Владелец = ТекущаяСтрока.Номенклатура Тогда
			
			ТекущаяСтрока.СтатусУказанияСерий = 1;
			
		Иначе
			
			ЗначенияПартииПоУмолчанию = НоменклатураВДокументахСервер.ЗначенияПартийНоменклатурыПоУмолчанию(ТекущаяСтрока.Номенклатура);
			
			ТекущаяСтрока.Серия = ?(ЗначениеЗаполнено(ЗначенияПартииПоУмолчанию), ЗначенияПартииПоУмолчанию, Справочники.ПартииНоменклатуры.ПустаяСсылка());
			ТекущаяСтрока.СтатусУказанияСерий = 1;
			
		КонецЕсли;
		
	Иначе
		
		ТекущаяСтрока.Серия = Справочники.ПартииНоменклатуры.ПустаяСсылка();
		ТекущаяСтрока.СтатусУказанияСерий = 0;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СерииНоменклатуры

Функция ПараметрыУказанияСерийСоответствиеНоменклатурыВЕТИС(Объект) Экспорт
	
	ПараметрыУказанияСерий = ПараметрыУказанияСерий();
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "РегистрСведений.СоответствиеНоменклатурыВЕТИС";
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьПартии");
	ПараметрыУказанияСерий.ТоварВШапке = Истина;
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.ИмяТЧСерии = "";
	ПараметрыУказанияСерий.ИмяТЧТовары = "";
	ПараметрыУказанияСерий.ИмяПоляКоличество = Неопределено;
	ПараметрыУказанияСерий.ИмяПоляСклад = Неопределено;
	ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта = "ЭтаФорма";
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает параметры указания серий в документе 'ВходящаяТранспортнаяОперацияВЕТИС'.
//
// Возвращаемое значение:
//	Структура - Состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерийВходящаяТранспортнаяОперацияВЕТИС(Объект) Экспорт
	
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьПартии");
	
	Если ТипЗнч(Объект.ТорговыйОбъект) = Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
		ИмяПоляСклад = "ТорговыйОбъект";
	Иначе
		ИмяПоляСклад = Неопределено;
	КонецЕсли;
	
	ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	УчитыватьСебестоимостьПоСериям = ИспользоватьСерииНоменклатуры;
	
	ПараметрыУказанияСерийТовары = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийТовары.ПолноеИмяОбъекта = "Документ.ВходящаяТранспортнаяОперацияВЕТИС";
	ПараметрыУказанияСерийТовары.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийТовары.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийТовары.ИменаПолейДополнительные.Добавить("ЕстьУточнения");
	
	ПараметрыУказанияСерийТовары.ИмяТЧСерии   = "Товары";
	ПараметрыУказанияСерийТовары.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийТовары.Дата         = Объект.Дата;
	
	
	ПараметрыУказанияСерийТоварыУточнение = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийТоварыУточнение.ПолноеИмяОбъекта = "Документ.ВходящаяТранспортнаяОперацияВЕТИС";
	ПараметрыУказанияСерийТоварыУточнение.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийТоварыУточнение.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийТоварыУточнение.ИмяТЧТовары   = "ТоварыУточнение";
	ПараметрыУказанияСерийТоварыУточнение.ИмяТЧСерии   = "ТоварыУточнение";
	ПараметрыУказанияСерийТоварыУточнение.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийТоварыУточнение.Дата         = Объект.Дата;
	
	ПараметрыУказанияСерий = Новый Структура;
	ПараметрыУказанияСерий.Вставить("Товары", ПараметрыУказанияСерийТовары); 
	ПараметрыУказанияСерий.Вставить("ТоварыУточнение", ПараметрыУказанияСерийТоварыУточнение); 
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает параметры указания серий в документе 'ИсходящаяТранспортнаяОперацияВЕТИС'.
//
// Возвращаемое значение:
//	Структура - Состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерийИсходящаяТранспортнаяОперацияВЕТИС(Объект) Экспорт
	
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьПартии");
	
	Если ТипЗнч(Объект.ТорговыйОбъект) = Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
		ИмяПоляСклад = "ТорговыйОбъект";
	Иначе
		ИмяПоляСклад = Неопределено;
	КонецЕсли;
	
	ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	УчитыватьСебестоимостьПоСериям = ИспользоватьСерииНоменклатуры;
	
	ПараметрыУказанияСерийТовары = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийТовары.ПолноеИмяОбъекта = "Документ.ИсходящаяТранспортнаяОперацияВЕТИС";
	ПараметрыУказанияСерийТовары.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийТовары.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийТовары.ИменаПолейДополнительные.Добавить("ЕстьУточнения");
	
	ПараметрыУказанияСерийТовары.ИмяТЧСерии   = "Товары";
	ПараметрыУказанияСерийТовары.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийТовары.Дата         = Объект.Дата;
	
	
	ПараметрыУказанияСерийТоварыУточнение = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийТоварыУточнение.ПолноеИмяОбъекта = "Документ.ИсходящаяТранспортнаяОперацияВЕТИС";
	ПараметрыУказанияСерийТоварыУточнение.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийТоварыУточнение.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийТоварыУточнение.ИмяТЧТовары   = "ТоварыУточнение";
	ПараметрыУказанияСерийТоварыУточнение.ИмяТЧСерии   = "ТоварыУточнение";
	ПараметрыУказанияСерийТоварыУточнение.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийТоварыУточнение.Дата         = Объект.Дата;
	
	ПараметрыУказанияСерий = Новый Структура;
	ПараметрыУказанияСерий.Вставить("ИспользоватьСерииНоменклатуры", ИспользоватьСерииНоменклатуры);
	ПараметрыУказанияСерий.Вставить("Товары", ПараметрыУказанияСерийТовары); 
	ПараметрыУказанияСерий.Вставить("ТоварыУточнение", ПараметрыУказанияСерийТоварыУточнение); 
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает параметры указания серий в документе 'ПроизводственнаяОперацияВЕТИС'.
//
// Возвращаемое значение:
//	Структура - Состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерийПроизводственнаяОперацияВЕТИС(Объект) Экспорт
	
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьПартии");
	
	Если ТипЗнч(Объект.ТорговыйОбъект) = Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
		ИмяПоляСклад = "ТорговыйОбъект";
	Иначе
		ИмяПоляСклад = Неопределено;
	КонецЕсли;
	
	ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	УчитыватьСебестоимостьПоСериям = ИспользоватьСерииНоменклатуры;
	
	ПараметрыУказанияСерийТовары = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийТовары.ПолноеИмяОбъекта = "Документ.ПроизводственнаяОперацияВЕТИС";
	ПараметрыУказанияСерийТовары.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийТовары.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийТовары.ИменаПолейДополнительные.Добавить("ЕстьУточнения");
	
	ПараметрыУказанияСерийТовары.ИмяТЧСерии   = "Товары";
	ПараметрыУказанияСерийТовары.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийТовары.Дата         = Объект.Дата;
	
	
	ПараметрыУказанияСерийСырье = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийСырье.ПолноеИмяОбъекта = "Документ.ПроизводственнаяОперацияВЕТИС";
	ПараметрыУказанияСерийСырье.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийСырье.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийСырье.ИмяТЧТовары   = "Сырье";
	ПараметрыУказанияСерийСырье.ИмяТЧСерии   = "Сырье";
	ПараметрыУказанияСерийСырье.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийСырье.Дата         = Объект.Дата;
	
	ПараметрыУказанияСерий = Новый Структура;
	ПараметрыУказанияСерий.Вставить("Товары", ПараметрыУказанияСерийТовары); 
	ПараметрыУказанияСерий.Вставить("Сырье", ПараметрыУказанияСерийСырье); 
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает параметры указания серий в документе 'ЗапросСкладскогоЖурналаВЕТИС'.
//
// Возвращаемое значение:
//	Структура - Состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерийЗапросСкладскогоЖурналаВЕТИС(Объект) Экспорт
	
	ПараметрыУказанияСерий = ПараметрыУказанияСерий();
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ЗапросСкладскогоЖурналаВЕТИС";
	
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьПартии");
	
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.ИмяТЧСерии                     = "Товары";
	ПараметрыУказанияСерий.ИмяПоляСклад                   = Неопределено;
	ПараметрыУказанияСерий.Дата                           = Объект.Дата;
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает параметры указания серий в документе 'ВходящаяТранспортнаяОперацияВЕТИС'.
//
// Возвращаемое значение:
//	Структура - Состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерийИнвентаризацияПродукцииВЕТИС(Объект) Экспорт
	
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьПартии");
	
	Если ТипЗнч(Объект.ТорговыйОбъект) = Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
		ИмяПоляСклад = "ТорговыйОбъект";
	Иначе
		ИмяПоляСклад = Неопределено;
	КонецЕсли;
	
	ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	УчитыватьСебестоимостьПоСериям = ИспользоватьСерииНоменклатуры;
	
	ПараметрыУказанияСерий = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ИнвентаризацияПродукцииВЕТИС";
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерий.ИмяТЧСерии   = "Товары";
	ПараметрыУказанияСерий.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерий.Дата         = Объект.Дата;
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// ToDo:Убрать лишние параметры
// Структура параметров указания серий, возвращаемая соотвествующей процедурой модуля менеджера документа (обработки).
// Содержит свойства:
//
// ОБЯЗАТЕЛЬНЫЕ:
//	ИспользоватьСерииНоменклатуры - признак, нужно ли в документе заполнять статусы указания серий 
//	ПоляСвязиСерий - массив с именами реквизитов ТЧ Товары и ТЧ Серии, по которым устанавливается
//					 связь между табличными частями (поля связи "Номенклатура" и "Характеристика" 
//					 присутсвуют всегда, их отдельно указывать не нужно)
//	СкладскиеОперации - массив значений ПеречислениеСсылка.СкладскиеОперации - складские операции, оформляемые документом
//	ПолноеИмяОбъекта - Строка - полное имя объекта. Например, Документ.РеализацияТоваровУслуг.
//	
//
// НЕОБЯЗАТЕЛЬНЫЕ:
//	ТолькоПросмотр - признак того, что серии в документе можно только просматривать (значение по умолчанию ЛОЖЬ)
//	ТоварВШапке - признак, что параметры указания серий определены для товара в шапке (иначе - для товара в ТЧ) (значение по умолчанию ЛОЖЬ)
//	БлокироватьДанныеФормы - признак того, что перед открытием форму указания серий, нужно заблокировать форму документа (значение по умолчанию ИСТИНА)
//								если ТолькоПросмотр = Истина, то данные формы не блокируются.
//
//	ИмяТЧТовары - имя табличной части со списком товаров (значение по умолчанию - "Товары")
//	ИмяТЧСерии - имя табличной части со списком серий (значение по умолчанию - "Серии")
//	ИмяПоляКоличество - имя поля в ТЧ "Товары", в котором пользователь редактирует количество (значение по умолчанию - "КоличествоУпаковок")
//	ИмяПоляСклад     - имя реквизита склада (значение по умолчанию - "Склад")
//	ИмяПоляПомещение - имя реквизита помещения, если не задано, значит в документе нет помещений
//	ИмяПоляДокументаРаспоряжения - Строка - если серии указываются в расходном ордере, то в этом параметре записывается имя поля распоряжения на отгрузку.
//											если серии указываются в накладной на поступление, то в этом параметрые записывается имя поле распоряжения на 
//												поступление.
//											Значение поля используются для отображения остатков в формах.
//
//	ЭтоОрдер - признак того, что документ является ордером (значение по умолчанию ЛОЖЬ)
//	ЭтоЗаказ - признак того, что документ является заказом (значение по умолчанию ЛОЖЬ)
//	ЭтоНакладная - признак того, что документ является накладной (значение по умолчанию ЛОЖЬ).
//
//	ТолькоСерииДляСебестоимости - нужно указывать только серии, по которым ведется учет себестоимости (значение по умолчанию ЛОЖЬ)
//	ПланированиеОтгрузки - использование параметра политики указания серий "УказыватьПриПланированииОтгрузки" (значение по умолчанию ЛОЖЬ)
//	ПланированиеОтора    - использование параметра политики указания серий "УказыватьПриПланированииОтбора" (значение по умолчанию ЛОЖЬ)
//	ПроверкаОтбора       - на адресном скакладе перед проверкой должны быть заполнены все серии, по которым ведется учет остатков
//	ФактОтбора - использование параметра политики указания серий "УказыватьПоФактуОтбора" (значение по умолчанию ЛОЖЬ)
//	ПодготовкаОрдера - параметр указывает, что ордер находится в статусе, когда происходит подготовка ордера и указание серий не обязательна (значение по умолчанию ЛОЖЬ)
//	ИменаПолейСтатусУказанияСерий - Массив - если в объекте несколько полей со статусом указания серий, то нужно добавить их имена в этот массив (значение по умолчанию пустой массив)
//	ИменаПолейДляОпределенияРаспоряжения - Массив - имена полей для определение распоржения, по которому отображаются остатки в форме подбора серий
//													имена полей табличной части указываются в формате Товары_ДокументРезерваСерий (значение по умолчанию пустой массив)
//	ИспользоватьАдресноеХранение - Булево -  на складе, по которому оформлен документ, используется адресное хранение (значение по умолчанию ЛОЖЬ)
//	ИмяИсточникаЗначенийВФормеОбъекта - Строка - значение по умолчанию "Объект", если данные хранятся в реквизитах формы, то нужно указать "ЭтоФорма"
//	ОтборПроверяемыхСтрок
//	ТолькоСерииСУчетомОстатков - Булево - необходимо указывать серии только тогда, когда по ним ведется учет остатков. (значение по умолчанию - ЛОЖЬ)
//	ОсобеннаяПроверкаСтатусовУказанияСерий - Булево - признак, что в модуле менеджера объявлена процедура ТекстЗапросаПроверкиЗаполненияСерий(ПараметрыУказанияСерий)(значение по умолчанию - ЛОЖЬ)
//	ПараметрыЗапроса - Структура - содержит параметры запроса, используемые в функции ТекстЗапросаЗаполненияСтатусовУказанияСерий.
//	СерииПриПланированииОтгрузкиУказываютсяВТЧСерии - Булево - значение по умолчанию - ЛОЖЬ.
//
// Возвращаемое значение:
//	Структура.
//
Функция ПараметрыУказанияСерий() Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ИспользоватьСерииНоменклатуры",Ложь);
	СтруктураПараметров.Вставить("УчитыватьСебестоимостьПоСериям",Ложь);
	СтруктураПараметров.Вставить("СкладскиеОперации",Новый Массив); 
	СтруктураПараметров.Вставить("ПоляСвязи", Новый Массив);
	СтруктураПараметров.Вставить("ПолноеИмяОбъекта", "");
	
	СтруктураПараметров.Вставить("ТолькоПросмотр",Ложь);
	СтруктураПараметров.Вставить("ТоварВШапке",Ложь);
	СтруктураПараметров.Вставить("БлокироватьДанныеФормы",Истина);
	СтруктураПараметров.Вставить("ИмяТЧТовары","Товары");
	СтруктураПараметров.Вставить("ИмяТЧСерии","Серии");
	СтруктураПараметров.Вставить("ИмяПоляКоличество","Количество");
	СтруктураПараметров.Вставить("ИмяПоляСклад","Склад");
	СтруктураПараметров.Вставить("ИмяПоляСкладОтправитель",Неопределено);
	СтруктураПараметров.Вставить("ИмяПоляСкладПолучатель",Неопределено);
	СтруктураПараметров.Вставить("ИмяПоляПомещение",Неопределено);
	СтруктураПараметров.Вставить("ЭтоОрдер",Ложь);
	СтруктураПараметров.Вставить("ЭтоЗаказ",Ложь);
	СтруктураПараметров.Вставить("ЭтоНакладная",Ложь);
	СтруктураПараметров.Вставить("ТолькоСерииДляСебестоимости",Ложь);
	СтруктураПараметров.Вставить("ПланированиеОтгрузки",Ложь);
	СтруктураПараметров.Вставить("ПланированиеОтбора",Ложь);
	СтруктураПараметров.Вставить("ПроверкаОтбора",Ложь);
	СтруктураПараметров.Вставить("ФактОтбора",Ложь);
	СтруктураПараметров.Вставить("ПодготовкаОрдера",Ложь);
	СтруктураПараметров.Вставить("РегистрироватьСерии", Истина);
	СтруктураПараметров.Вставить("Дата",Дата(1,1,1));
	СтруктураПараметров.Вставить("ИменаПолейСтатусУказанияСерий",Новый Массив);
	СтруктураПараметров.Вставить("ИменаПолейДляОпределенияРаспоряжения",Новый Массив);
	СтруктураПараметров.Вставить("ИменаПолейДополнительные",Новый Массив);
	СтруктураПараметров.Вставить("ИспользоватьАдресноеХранение",Ложь);
	СтруктураПараметров.Вставить("ИмяИсточникаЗначенийВФормеОбъекта","Объект");
	СтруктураПараметров.Вставить("ОтборПроверяемыхСтрок", Неопределено);
	СтруктураПараметров.Вставить("ТолькоСерииСУчетомОстатков", Ложь);
	СтруктураПараметров.Вставить("ОсобеннаяПроверкаСтатусовУказанияСерий", Ложь);
	СтруктураПараметров.Вставить("НужноОкруглятьКоличество", Истина);
	СтруктураПараметров.Вставить("ПараметрыЗапроса", Новый Структура);
	СтруктураПараметров.Вставить("СерииПриПланированииОтгрузкиУказываютсяВТЧСерии", Ложь);
	СтруктураПараметров.Вставить("ИспользуютсяТоварныеМеста", Ложь);
	СтруктураПараметров.Вставить("СерииМогутУказыватьсяВТаблицеУточнений", Ложь);
	
	СтруктураПараметров.Вставить("ОперацияДокумента", Неопределено);
	
	Возврат СтруктураПараметров;
	
КонецФункции

Функция ЗначенияРеквизитовДляЗаполненияПараметровУказанияСерий(Объект, ИменаРеквизитов) Экспорт
	
	Если Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Объект)) Тогда
		Структура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект, ИменаРеквизитов);
	Иначе
		Структура = Новый Структура(ИменаРеквизитов);
		ЗаполнитьЗначенияСвойств(Структура, Объект);
	КонецЕсли;
	Если Структура.Свойство("Дата") И НЕ ЗначениеЗаполнено(Структура.Дата) Тогда
		Структура.Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	Если Структура.Свойство("ДатаОтгрузки") И НЕ ЗначениеЗаполнено(Структура.ДатаОтгрузки) Тогда
		Структура.ДатаОтгрузки = ТекущаяДатаСеанса();
	КонецЕсли;
	Возврат Структура;
	
КонецФункции


#КонецОбласти

#Область ХарактеристикиНоменклатуры

Процедура ЗаполнитьПризнакиИспользованияХарактеристикВЕТИС(Форма) Экспорт
	
	ЕстьРеквизитОбъект = Ложь;
	
	МассивРеквизитов = Форма.ПолучитьРеквизиты();
	
	Для Каждого Реквизит Из МассивРеквизитов Цикл
		Если Реквизит.Имя = "Объект" Тогда
			ЕстьРеквизитОбъект = Истина;
			Прервать
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьРеквизитОбъект Тогда
		
		Если Форма.Объект.Свойство("Ссылка") И Не Форма.Объект.Ссылка = Неопределено Тогда
			
			МетаданныеОбъекта = Форма.Объект.Ссылка.Метаданные();
			
			МассивИменТабличныхЧастей = Новый Массив;
			
			Для Каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
				
				Если НЕ ТабличнаяЧасть.Реквизиты.Найти("Характеристика") = Неопределено Тогда
					МассивИменТабличныхЧастей.Добавить(ТабличнаяЧасть.Имя);
				КонецЕсли;
				
			КонецЦикла;
			
			Для Каждого ИмяТабличнойЧасти Из МассивИменТабличныхЧастей Цикл
				
				Для Каждого СтрокаТЧ Из Форма.Объект[ИмяТабличнойЧасти] Цикл
					Если СтрокаТЧ.Свойство("Номенклатура")Тогда
						Если СтрокаТЧ.Свойство("ХарактеристикиИспользуются") Тогда
							СтрокаТЧ.ХарактеристикиИспользуются = ?(ЗначениеЗаполнено(СтрокаТЧ.Номенклатура), СтрокаТЧ.Номенклатура.ИспользоватьХарактеристики, Ложь);
							Если Не СтрокаТЧ.ХарактеристикиИспользуются И ЗначениеЗаполнено(СтрокаТЧ.Характеристика) Тогда СтрокаТЧ.ХарактеристикиИспользуются = Истина КонецЕсли;
						КонецЕсли;
						Если СтрокаТЧ.Свойство("ПроверятьЗаполнениеХарактеристики") Тогда
							СтрокаТЧ.ПроверятьЗаполнениеХарактеристики = ?(ЗначениеЗаполнено(СтрокаТЧ.Номенклатура), СтрокаТЧ.Номенклатура.ПроверятьЗаполнениеХарактеристики, Ложь) ;
						КонецЕсли;
						Если СтрокаТЧ.Свойство("ПроверятьЗаполнениеПартий") Тогда
							СтрокаТЧ.ПроверятьЗаполнениеПартий = ?(ЗначениеЗаполнено(СтрокаТЧ.Номенклатура), СтрокаТЧ.Номенклатура.ПроверятьЗаполнениеПартий, Ложь) ;
						КонецЕсли;
						Если СтрокаТЧ.Свойство("ИспользоватьПартии") Тогда
							СтрокаТЧ.ИспользоватьПартии = ?(ЗначениеЗаполнено(СтрокаТЧ.Номенклатура), СтрокаТЧ.Номенклатура.ИспользоватьПартии, Ложь) ;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПересчетКоличества

Функция ПересчитатьКоличествоЕдиницВЕТИС(Количество, Номенклатура, ЕдиницаИзмеренияВЕТИС, НужноОкруглять, КэшированныеЗначения, ТекстОшибки = Неопределено) Экспорт
	
	НовоеКоличествоВЕТИС = Неопределено;
	ТекстОшибки = Неопределено;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		ДанныеЕдиницыИзмерения = ПолучитьКоэффициентЕдиницыИзмеренияВЕТИС(
									ЕдиницаИзмеренияВЕТИС, 
									КэшированныеЗначения,
									Номенклатура);
		
		Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) Тогда
			
			Если ДанныеЕдиницыИзмерения.КодОшибки <> 0 Тогда
				
				ТекстОшибки = ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(
										ДанныеЕдиницыИзмерения.КодОшибки,
										Номенклатура, 
										ЕдиницаИзмеренияВЕТИС, 
										ДанныеЕдиницыИзмерения.ТипИзмеряемойВеличины);
				
				Возврат Неопределено;
				
			КонецЕсли;
			
			НовоеКоличествоВЕТИС = Количество / ДанныеЕдиницыИзмерения.Коэффициент;
		
			Если НужноОкруглять
				И ДанныеЕдиницыИзмерения.НужноОкруглятьКоличество Тогда
				
				НовоеКоличествоВЕТИС = Окр(НовоеКоличествоВЕТИС, 0, РежимОкругления.Окр15как20);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	Возврат НовоеКоличествоВЕТИС;
	
КонецФункции

Функция ПересчитатьКоличествоЕдиниц(КоличествоВЕТИС, Номенклатура, ЕдиницаИзмеренияВЕТИС, НужноОкруглять, КэшированныеЗначения, ТекстОшибки = Неопределено) Экспорт
	
	НовоеКоличество = Неопределено;
	ТекстОшибки = Неопределено;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		ДанныеЕдиницыИзмерения = ПолучитьКоэффициентЕдиницыИзмеренияВЕТИС(
									ЕдиницаИзмеренияВЕТИС, 
									КэшированныеЗначения,
									Номенклатура);
		
		Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) Тогда
			
			Если ДанныеЕдиницыИзмерения.КодОшибки <> 0 Тогда
				
				ТекстОшибки = ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(
										ДанныеЕдиницыИзмерения.КодОшибки,
										Номенклатура,
										ЕдиницаИзмеренияВЕТИС,
										ДанныеЕдиницыИзмерения.ТипИзмеряемойВеличины,
										"ВЕТИС");
				
				Возврат Неопределено;
				
			КонецЕсли;
			
			НовоеКоличество = КоличествоВЕТИС * ДанныеЕдиницыИзмерения.Коэффициент;
			
			Если НужноОкруглять
				И ДанныеЕдиницыИзмерения.НужноОкруглятьКоличество Тогда
				
				НовоеКоличество = Окр(НовоеКоличество, 0, РежимОкругления.Окр15как20);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	Возврат НовоеКоличество;
	
КонецФункции

Функция ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(КодОшибки, Номенклатура, ЕдиницаИзмеренияВЕТИС, ТипИзмеряемойВеличины, СуффиксКоличества = "")
	
	ПересчетВЕТИС        = СокрЛП(СуффиксКоличества) = "ВЕТИС";
	ТекстЕдиницыХранения = ?(ПересчетВЕТИС, НСтр("ru = 'в единицу хранения'"), НСтр("ru = 'количества (ВетИС)'"));
	
	ШаблонСообщенияНеЗаполненаЕдиницаИзмерения    = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%, т.к. не заполнено поле ""Единица измерения"" в карточке единицы измерения ВетИС ""%ЕдиницаИзмеренияВЕТИС%""'");
	ШаблонСообщенияНеУказанТипИзмеряемойВеличины  = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%, т.к. в карточке номенклатуры ""%Номенклатура%"" выключена возможность указания количества в единицах измерения %ТипИзмеряемойВеличины%'");
	ШаблонСообщенияНеСопоставленыЕдиницыИзмерения = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%. Приведите в соответствие единицу измерения в карточке единицы измерения ВетИС ""%ЕдиницаИзмеренияВЕТИС%"" с единицей хранения номенклатуры ""%Номенклатура%"" или укажите %ТипКоличества% вручную'");
	
	Если КодОшибки = 1 Тогда
		ТекстСообщения = ШаблонСообщенияНеЗаполненаЕдиницаИзмерения;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаХранения%",       ТекстЕдиницыХранения);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаИзмеренияВЕТИС%", Строка(ЕдиницаИзмеренияВЕТИС));
	ИначеЕсли КодОшибки = 2 Тогда
		
		ИмяТипаИзмеряемойВеличины = "";  //'веса', 'объема', 'длины'
		
		ТекстСообщения = ШаблонСообщенияНеУказанТипИзмеряемойВеличины;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаХранения%",       ТекстЕдиницыХранения);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%",          Строка(Номенклатура));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипИзмеряемойВеличины%", ИмяТипаИзмеряемойВеличины);
		
	ИначеЕсли КодОшибки = 3 Тогда
		ТекстТипаКоличества = ?(ПересчетВЕТИС, НСтр("ru = 'количество'"), НСтр("ru = 'количество (ВетИС)'"));
		
		ТекстСообщения = ШаблонСообщенияНеСопоставленыЕдиницыИзмерения;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаХранения%",       ТекстЕдиницыХранения);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаИзмеренияВЕТИС%", Строка(ЕдиницаИзмеренияВЕТИС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%",          Строка(Номенклатура));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипКоличества%",          Строка(Номенклатура));
	Иначе
		ТекстСообщения = "";
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

// Возвращает сведения о коэффициенте пересчета единицы измерения ВетИС.
//
// Параметры:
//	ЕдиницаИзмеренияВЕТИС	- СправочникСсылка.ЕдиницыИзмеренияВЕТИС	- Единица измерения ВетИС, коэффициент которой нужно 
//																		получить.
//	КэшированныеЗначения	- Структура									- Сохраненные значения параметров, используемых при обработке 
//																		строки таблицы.
//	Номенклатура			- СправочникСсылка.Номенклатура				- Номенклатура для единицы хранения, которой осуществляется 
//																		получение коэффициента пересчета.
//
// Возвращаемое значение:
//	Структура - Структура со свойствами:
//		* КодОшибки					- Число				- Код ошибки получения коэффициента.
//															0 - Нет ошибок;
//															1 - Не заполнена единица измерения в с правочнике 'ЕдиницыИзмеренияВЕТИС';
//															2 - В справочнике 'Номенклатура' выключена возможность пересчета количества 
//																в соответствующую мерную единицу измерения;
//															3 - Не удалось сопоставить единицу хранения справочника 'Номенклатура' 
//																с единицей измерения справочника 'ЕдиницыИзмеренияВЕТИС'.
//		* Коэффициент				- Число				- Коэффициент пересчета единицы измерения ВетИС.
//		* ТипИзмеряемойВеличины		- ПеречислениеСсылка.ТипыИзмеряемыхВеличин - Тип измеряемой величины единицы измерения 
//																					справочника 'ЕдиницыИзмеренияВЕТИС'.
//		* НужноОкруглятьКоличество	- Булево, Истина	- Признак необходимости округления количества при пересчете.
//
Функция ПолучитьКоэффициентЕдиницыИзмеренияВЕТИС(ЕдиницаИзмеренияВЕТИС, КэшированныеЗначения, Номенклатура = Неопределено) Экспорт
	
	Результат = Новый Структура("КодОшибки, Коэффициент, ТипИзмеряемойВеличины, НужноОкруглятьКоличество");
	
	Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) Тогда
		
		КлючКоэффициента = КлючКэшаУпаковки(Номенклатура, ЕдиницаИзмеренияВЕТИС);
		
		Если КэшированныеЗначения <> Неопределено Тогда
			Кэш = КэшированныеЗначения.КоэффициентыУпаковок[КлючКоэффициента];
		Иначе
			Кэш = Неопределено;
		КонецЕсли; 
		
		Если Кэш = Неопределено Тогда
				ЗначенияРеквизитов = ДанныеЕдиницыИзмренияВЕТИС(
										ЕдиницаИзмеренияВЕТИС, 
										Номенклатура,
										КэшированныеЗначения);
				
				ЗаполнитьЗначенияСвойств(Результат, ЗначенияРеквизитов);
		Иначе
			Результат = Кэш;
		КонецЕсли;
	Иначе
		Результат.КодОшибки                = 0;
		Результат.Коэффициент              = 1;
		Результат.ТипИзмеряемойВеличины    = Неопределено;
		Результат.НужноОкруглятьКоличество = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает сведения о коэффициенте пересчета единицы измерения ВетИС.
//
// Параметры:
//	ЕдиницаИзмеренияВЕТИС	- СправочникСсылка.ЕдиницыИзмеренияВЕТИС	- Единица измерения ВетИС, коэффициент которой нужно 
//																		получить.
//	Номенклатура			- СправочникСсылка.Номенклатура				- Номенклатура для единицы хранения, которой осуществляется 
//																		получение коэффициента пересчета.
//	КэшированныеЗначения	- Структура									- Сохраненные значения параметров, используемых при обработке 
//																		строки таблицы.
//
// Возвращаемое значение:
//	Структура - см. описание модуля менеджера УпаковкиЕдиницы.КоэффициентЕдиницыИзмеренияПоВЕТИС.
//
Функция ДанныеЕдиницыИзмренияВЕТИС(ЕдиницаИзмеренияВЕТИС, Номенклатура, КэшированныеЗначения) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КодОшибки",                0);
	Результат.Вставить("Коэффициент",              1);
	Результат.Вставить("КэшироватьДанные",         Ложь);
	Результат.Вставить("ТипИзмеряемойВеличины",    Неопределено);
	Результат.Вставить("НужноОкруглятьКоличество", Ложь);
	
	Если НЕ ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) ИЛИ НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		
		Результат.Коэффициент      = 1;
		Результат.КэшироватьДанные = Истина;
		
		Возврат Результат;
		
	Иначе
		
		ЕдиницаИзмеренияНоменклатуры = Номенклатура.ЕдиницаИзмерения;
		
		Если ЕдиницаИзмеренияВЕТИС.ЕдиницаИзмерения = ЕдиницаИзмеренияНоменклатуры Тогда
			Возврат Результат;
		КонецЕсли;
		
		ЕдиницаИзмеренияДляОбхода = ЕдиницаИзмеренияВЕТИС;
		ОграничительИтераций = 0; //Нужен, поскольку нет проверок на циклические ссылки в базовых единицах измерения
		Коэффициент = 1;
		
		Пока ОграничительИтераций < 10  Цикл
			
			Коэффициент = Коэффициент * ЕдиницаИзмеренияДляОбхода.Коэффициент;
			
			Если ЕдиницаИзмеренияДляОбхода.ЕдиницаИзмерения = ЕдиницаИзмеренияНоменклатуры Тогда
				Результат.Коэффициент = Коэффициент;
				Возврат Результат;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ЕдиницаИзмеренияДляОбхода.БазоваяЕдиницаИзмерения) Тогда
				Прервать
			КонецЕсли;
			
			ОграничительИтераций = ОграничительИтераций + 1;
			ЕдиницаИзмеренияДляОбхода = ЕдиницаИзмеренияДляОбхода.БазоваяЕдиницаИзмерения;
			
		КонецЦикла;
		
		Результат.КодОшибки   = 1;
		Результат.Коэффициент = 1;
		Возврат Результат;
		
	КонецЕсли;
	
	Если Результат.КэшироватьДанные Тогда
		
		КлючКоэффициента = КлючКэшаУпаковки(Номенклатура, ЕдиницаИзмеренияВЕТИС);
		
		ДанныеКлюча = Новый Структура;
		ДанныеКлюча.Вставить("КодОшибки",                Результат.КодОшибки);
		ДанныеКлюча.Вставить("Коэффициент",              Результат.Коэффициент);
		ДанныеКлюча.Вставить("ТипИзмеряемойВеличины",    Результат.ТипИзмеряемойВеличины);
		ДанныеКлюча.Вставить("НужноОкруглятьКоличество", Результат.НужноОкруглятьКоличество);
		
		КэшированныеЗначения.КоэффициентыУпаковок.Вставить(КлючКоэффициента, ДанныеКлюча);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция КлючКэшаУпаковки(Номенклатура, Упаковка) Экспорт
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		КлючНоменклатура = Строка(Номенклатура.УникальныйИдентификатор());
	Иначе
		КлючНоменклатура = "ПустоеЗначение";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Упаковка) Тогда
		КлючУпаковка = Строка(Упаковка.УникальныйИдентификатор());
	Иначе
		КлючУпаковка = "ПустоеЗначение";
	КонецЕсли;
	
	Возврат КлючНоменклатура + КлючУпаковка;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ПолучитьДанныеХозяйствующгоСубъектаВЕТИС(Субъект) Экспорт
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Субъект, "СоответствуетОрганизации, Контрагент");
	
КонецФункции

Функция ХозяйствующийСубъектПоОрганизации(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Субъект.Ссылка КАК ХозяйствующийСубъект
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК Субъект
	|ГДЕ
	|	Субъект.Контрагент = &Организация
	|	И НЕ Субъект.Ссылка.ПометкаУдаления";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 Тогда 
		Выборка.Следующий();
		Возврат Выборка.ХозяйствующийСубъект;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Неопределено;
	
КонецФункции

Процедура ПолучитьЗапасыИзХранилища(МассивЗапасов, АдресЗапасовВХранилище, ИмяТабличнойЧасти, ЕстьХарактеристики = Истина, ЕстьПартии = Истина) Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ОтборПродукция", Неопределено);
	
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	Для каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		 
		НоваяСтрока = Новый Структура("Номенклатура, Характеристика, Серия, Количество, КоличествоИзменение,  Продукция, ЕдиницаИзмеренияВЕТИС, СтранаПроизводства, НоменклатураДляВыбора, СопоставлениеТекст");
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗагрузки);
		НоваяСтрока.Серия = СтрокаЗагрузки.Партия;
		ЗаполнитьПродукциюВЕТИС(НоваяСтрока, ПараметрыЗаполнения);
		
		Если ЗначениеЗаполнено(НоваяСтрока.Продукция) Тогда
			ИнтеграцияВЕТИС.ПроверитьОчиститьЕдиницуИзмеренияВЕТИС(НоваяСтрока);
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(НоваяСтрока.ЕдиницаИзмеренияВЕТИС) Тогда
			ПересчитатьКоличествоЕдиницВЕТИС(НоваяСтрока.Количество, НоваяСтрока.Номенклатура, НоваяСтрока.ЕдиницаИзмеренияВЕТИС, Ложь, Неопределено);
		КонецЕсли; 
		
		МассивЗапасов.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

Функция НаименованиеОрганизацииПоУмолчанию() Экспорт
	
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	Если Организация.Пустая() Тогда
		
		Возврат НСтр("ru = 'ООО ""Кухни Ассоль""'");
		
	Иначе
		
		Возврат Организация.НаименованиеПолное;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти 