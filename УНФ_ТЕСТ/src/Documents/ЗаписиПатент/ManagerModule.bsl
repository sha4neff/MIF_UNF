#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	&Период,
	|	&Организация,
	|	&Патент,
	|	ЗаписиКнигаДоходовПатент.Ссылка,
	|	ЗаписиКнигаДоходовПатент.НомерСтроки,
	|	ЗаписиКнигаДоходовПатент.Содержание,
	|	ЗаписиКнигаДоходовПатент.Доход КАК Графа4,
	|	ЗаписиКнигаДоходовПатент.НомерПервичногоДокумента,
	|	ЗаписиКнигаДоходовПатент.ДатаПервичногоДокумента
	|ИЗ
	|	Документ.ЗаписиПатент.ЗаписиКнигаДоходовПатент КАК ЗаписиКнигаДоходовПатент
	|ГДЕ
	|	ЗаписиКнигаДоходовПатент.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Период", ДокументСсылка.Дата);
	Запрос.УстановитьПараметр("Организация", ДокументСсылка.Организация);
	Запрос.УстановитьПараметр("Патент", ДокументСсылка.Патент);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Результат.Колонки.Добавить("РеквизитыПервичногоДокумента");
	
	Для Каждого Строка Из Результат Цикл
		Строка.РеквизитыПервичногоДокумента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '№ %1 от %2'"),
			Строка.НомерПервичногоДокумента, Формат(Строка.ДатаПервичногоДокумента, "ДЛФ=D"))
	КонецЦикла;
	
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаКнигаУчетаДоходовПатент", Результат);
	
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли
